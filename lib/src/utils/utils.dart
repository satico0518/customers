import 'dart:io';

import 'package:path_provider/path_provider.dart';

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
