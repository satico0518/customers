import 'dart:io';

import 'package:customers/src/providers/form-questions.provider.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> _localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile() async {
  final path = await _localPath();
  return File('$path/entrevistas.txt');
}

Future<File> writeFileContent(String content) async {
  final file = await _localFile();

  // Write the file
  return file.writeAsString(content);
}

String returnIdTypeCode(String text) {
  String code = 'CC';
  switch (text) {
    case 'Cedula Ciudadanía':
      code = 'CC';
      break;
    case 'NIT':
      code = 'NIT';
      break;
    case 'Cedula Extrangería':
      code = 'CE';
      break;
    case 'Registro Civil':
      code = 'RC';
      break;
    case 'Otro':
      code = 'Otro';
      break;
    default:
      code = 'N/A';
  }
  return code;
}

Future<String> sendFormListEmail(String fileUrl) async {
  final shop = await ShopDBProvider.db.getShop();
  String platformResponse;
  final Email email = Email(
    body: '''
        <p>Usted ha recibido un link para descargar el archivo con las entrevistas solicitadas</p>
        Haga clic <a href="$fileUrl">aqui</a> para descargar el archivo
        <p>Recuerde que el archivo estará disponible por 2 días</p>
    ''',
    subject: 'PaseYa - Link Descarga de Archivo CSV',
    recipients: [shop.email],
    isHTML: true,
  );

  try {
    await FlutterEmailSender.send(email);
    platformResponse = 'Email Enviado exitosamente!';
  } catch (error) {
    platformResponse = error.toString();
  }
  return platformResponse;
}

Future<String> sendSingleFormEmail(Map<String, dynamic> form) async {
  final shop = await ShopDBProvider.db.getShop();
  String platformResponse;
  String employeeSection = '''
    <div>
      <p>${getQuestion(7)}</p>
      Respuesta: ${form['employeeAcceptYourSymptoms'] == 1 ? 'SI' : 'NO'}
    </div>
    <div>
      <p>${getQuestion(8)}</p>
      Respuesta: ${form['employeeAcceptHomeSymptoms'] == 1 ? 'SI' : 'NO'}
    </div>
    <div>
      <p>${getQuestion(9)}</p>
      Respuesta: ${form['employeeAcceptVacationSymptoms'] == 1 ? 'SI' : 'NO'}
    </div>
  ''';
  final Email email = Email(
    body: '''
      <h2>Entrevista Individual</h2>
      <div>
          Identificacion: ${returnIdTypeCode(form['identificationType'])} ${form['identification']}<br>
          Nombre: ${form['name']} ${form['lastName']}<br>
          Telefono: ${form['contact']}<br>
          Email: ${form['email']}<br>
      </div>
      <h3>Formulario COVID 19</h3>
      <div>
          <p>${getQuestion(1)}</p>
          Respuesta: ${form['yourSymptoms'] == 1 ? 'SI' : 'NO'}
          <p>Observaciones: ${form['yourSymptomsDesc']}</p>
      </div>
      <div>
          <p>${getQuestion(2)}</p>
          Respuesta: ${form['yourHomeSymptoms'] == 1 ? 'SI' : 'NO'}
      </div>
      <div>
          <p>${getQuestion(3)}</p>
          Respuesta: ${form['haveBeenIsolated'] == 1 ? 'SI' : 'NO'}
          <p>Observaciones: ${form['haveBeenIsolatedDesc']}</p>
      </div>
      <div>
          <p>${getQuestion(4)}</p>
          Respuesta: ${form['haveBeenVisited'] == 1 ? 'SI' : 'NO'}
          <p>Observaciones: ${form['haveBeenVisitedDesc']}</p>
      </div>
      <div>
          <p>${getQuestion(5)}</p>
          Respuesta: ${form['haveBeenWithPeople'] == 1 ? 'SI' : 'NO'}
      </div>
      <div>
          <p>${getQuestion(6)}</p>
          Respuesta: ${form['visitorAccept'] == 1 ? 'SI' : 'NO'}
      </div>
      ${form['isEmployee'] == 1 ? employeeSection : ''}
    ''',
    subject: 'PaseYa - Entrevista Individual',
    recipients: [shop.email],
    isHTML: true,
  );

  try {
    await FlutterEmailSender.send(email);
    platformResponse = 'Email Enviado exitosamente!';
  } catch (error) {
    platformResponse = error.toString();
  }
  return platformResponse;
}

Future<String> uploadFile(File file, String fileName) async {
  try {
    final StorageReference fbStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = fbStorageRef.putFile(file);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;

    var downloadUrl = await snapshot.ref.getDownloadURL();
    if (uploadTask.isComplete) return downloadUrl.toString();

    return null;
  } catch (e) {
    return null;
  }
}

String handleMessage(String message) {
  if (message.contains('ERROR_WEAK_PASSWORD')) {
    return 'Password demasiado debil';
  } else if (message.contains('ERROR_INVALID_EMAIL')) {
    return 'Formato de correo invalido';
  } else if (message.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
    return 'El correo ya existe';
  } else
    return 'error desconocido: $message';
}
