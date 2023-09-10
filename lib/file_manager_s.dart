import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
// import 'package:open_file/open_file.dart';

void pickFile() async {
  // opens storage to pick files and the picked file or files
  // are assigned into result and if no file is chosen result is null.
  // you can also toggle "allowMultiple" true or false depending on your need
  final result = await FilePicker.platform.pickFiles(allowMultiple: false);

  // if no file is picked
  if (result == null) return;

  // we will log the name, size and path of the
  // first picked file (if multiple are selected)
  /*print(result.files.first.name);
    print(result.files.first.size);
    print(result.files.first.path);*/
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
    return 'Error';
  }
}
