import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';


Future<String> pickFile() async {
  // opens storage to pick files and the picked file or files
  // are assigned into result and if no file is chosen result is null.
  // you can also toggle "allowMultiple" true or false depending on your need
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: false,
    allowedExtensions: ['mp3']
  );

  // if no file is picked
  if (result == null) return '';

  // we get the file from result object
  final file = result.files.first;

  return file.path ?? '';
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> writeDocument(String filename, String content) async {
  final path = await _localPath;
  final file = File('$path/$filename.txt');

  // Write the file
  return file.writeAsString(content);
}

Future<String> readDocument(String filename) async {
  try {
    final path = await _localPath;
    final file = File('$path/$filename.txt');

    // Read the file
    final contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0
    return 'No se pudo leer el archivo';
  }
}
