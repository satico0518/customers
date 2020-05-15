import 'dart:io';

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

Future<String> sendEmail(String fileUrl) async {
  String platformResponse;
  final Email email = Email(
    body: '''<h2>Ruta del archivo:</h2> <br/>
      $fileUrl <br/>
      <h3>Recuerde que el archivo estara disponible por 2 dias</h3>.
    ''',
    subject: 'PaseYa - Link Descarga de Archivo CSV',
    recipients: ['davo.gomez1@gmail.com'],
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
