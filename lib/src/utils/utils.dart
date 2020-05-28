import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/pages/home-page.dart';
import 'package:customers/src/pages/login-page.dart';
import 'package:customers/src/pages/qr-reader-page.dart';
import 'package:customers/src/providers/auth.shared-preferences.dart';
import 'package:customers/src/providers/form-questions.provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> _localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile() async {
  final path = await _localPath();
  return File('$path/encuestas.txt');
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

Future<String> sendFormListEmail(String fileUrl, UserBloc bloc) async {
  String platformResponse;
  final Email email = Email(
    body: '''
        <p>Usted ha recibido un link para descargar el archivo con las encuestas solicitadas</p>
        Haga clic en el siguiente link para descargar el archivo<br>
        $fileUrl
        <p>Recuerde que el archivo estará disponible por 2 días</p>
    ''',
    subject: 'PaseYa - Link Descarga de Archivo CSV',
    recipients: [bloc.shopEmail],
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

Future<String> sendSingleFormEmail(Map<String, dynamic> form, UserBloc bloc) async {
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
      <h2>Encuesta Individual</h2>
      <div>
          Registro de ${form['gettingIn'] != null ? (form['gettingIn'] ? 'Ingreso' : 'Salida') : 'NA'}<br>
          <hr>
          Temperatura Registrada: ${form['temperature']}<br>
          Fecha: ${getStringDateFromtimestamp(form['insertDate'])}<br>
          Identificacion: ${returnIdTypeCode(form['identificationType'])} ${form['identification']}<br>
          Nombre: ${form['name']} ${form['lastName']}<br>
          Telefono: ${form['contact']}<br>
          Email: ${form['email']}<br>
      </div>
      <h3>Formulario Salud y Distanciamiento Social</h3>
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
    subject: 'PaseYa - Encuesta Individual',
    recipients: [bloc.shopEmail],
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

String capitalizeWord(String word) {
  return '${word[0].toUpperCase()}${word.substring(1)}';
}

String getStringDateFromtimestamp(Timestamp time) {
  if (time == null) return '';
  return DateTime.parse(time.toDate().toString()).toString().split('.')[0];
}

String getFormatedDate(DateTime dateTime) {
  if (dateTime == null) return '';
  final month = dateTime.month < 10 ? '0' + dateTime.month.toString() : dateTime.month;
  return '${dateTime.day}/$month/${dateTime.year}';
}

Future<void> getInitialRoute() async {
  final _prefs = new PreferenceAuth();
  await _prefs.initPrefs();  
  if (_prefs.isUserLoggedIn)
    _prefs.initialRoute = HomePage.routeName;
  else if (_prefs.isShopLoggedIn)
    _prefs.initialRoute = QRReaderPage.routeName;
  else
    _prefs.initialRoute = LoginPage.routeName;
}

String getTermsAndConditionsText() {
  return '''PRIMERO: Significados: (i) “Datos Personales” significa la información personal registrada en cualquier base de datos que
la haga susceptible de tratamiento, que para efectos de la presente autorización, al ser registrada en la Aplicación por el
Usuario/Titular, en su conjunto, genera la posibilidad de identificar al Usuario/Titular de conformidad con las protecciones y
derechos establecidos en la Ley 1581 de 2012 de la República de Colombia y demás regulación aplicable; (ii) “Datos
Personales Sensibles” significa aquellos relativos a la intimidad del Usuario/Titular que para efectos de la presente
autorización son datos relacionados con la salud del Usuario/Titular de conformidad con las protecciones y derechos
establecidos en la Ley 1581 de 2012 de la República de Colombia y demás regulación aplicable; (iii) “Usuario/Titular”
significa la persona natural o el individuo que accede a la Aplicación, y en la que libre y voluntariamente procede a registrar
sus Datos Personales y Datos Personales Sensibles, y a quien el Responsable le garantizará en todo momento los derechos y
protecciones establecidos en la Ley 1581 de 2012 de la República de Colombia y demás regulación aplicable; (iv)
“Responsable” significa la empresa FastFire de Colombia SAS con NIT 900.596.937-8, empresa debidamente constituida de
conformidad con las leyes de la República de Colombia; (v) “Aplicación” significa el software al que el Usuario/Titular
accede, de propiedad del Responsable y en el que el Usuario/Titular registra sus Datos Personales y Datos Personales
Sensibles. SEGUNDO: Autorización: Con la aceptación de la presente autorización, y el ingreso de los Datos Personales y
Datos Personales Sensibles en la Aplicación, el Usuario/Titular de los Datos Personales declara que el procesamiento de sus
Datos Personales para el(los) siguiente(s) fin(es) relacionado(s) a continuación, por parte del Responsable ha(n) sido
autorizado(s) y así mismo acuerda y autoriza el procesamiento de los Datos Personales Sensibles para el(los) fin(es) descrito(s)
a continuación por parte del Responsable en el territorio de la República de Colombia: (a) Registro en la aplicación del
Responsable de los Datos Personales y Datos Personales Sensibles para el seguimiento de los síntomas del Usuario/Titular
para que éste registre si se encuentra con síntomas o infectado con el nuevo coronavirus también conocido como
SARS-CoV-2. (b) Registro de personas que ingresan a empresas, establecimientos de comercio o cualquier entidad con el fin
de poder control de flujo y realizar trazabilidad en caso de aparecer algún caso de infección con el nuevo coronavirus también conocido como SARS-CoV-2. (c) Realizar tamizaje y encuesta del estado de salud de cada persona que ingrese a
empresas, establecimientos de comercio o cualquier entidad con el fin de identificar un posible infectado con el nuevo
coronavirus también conocido como SARS-CoV-2. (d) Cumplir con los protocolos de inspección, vigilancia y
control establecidos por el gobierno para protección de la salud la comunidad en general. TERCERO: Transmisión y
transferencia: Ni los Datos Personales ni los Datos Personales Sensibles serán transferidos ni transmitidos a ningún tercero.
CUARTO: Autoridades Gubernamentales: El Usuario/Titular declara conocer y aceptar que el Responsable puede requerir
poner los Datos Personales, los Datos Personales Sensibles o parte de ellos a disposición de las autoridades competentes (ya
sea autoridades judiciales y administrativas), incluyendo pero sin limitar, autoridades sanitarias en la República de Colombia
en cualquier nivel (municipal, distrital, departamental y/o nacional).
ACEPTACIÓN: Haciendo Click en “Sí Acepto”, el Usuario/Titular otorga la autorización de uso y protección de Datos
Personales y Datos Personales Sensibles de conformidad con los Términos y Condiciones anteriormente establecidos.''';
}
