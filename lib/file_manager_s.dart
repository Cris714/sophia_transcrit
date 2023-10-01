import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';


Future<PlatformFile?> pickFile() async {
  // opens storage to pick files and the picked file or files
  // are assigned into result and if no file is chosen result is null.
  // you can also toggle "allowMultiple" true or false depending on your need
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: true,
    allowedExtensions: ['m4a', 'mp3', 'webm', 'mp4', 'mpga', 'wav', 'mpeg']
  );

  // if no file is picked
  if (result == null) return null;

  // we get the file from result object
  final file = result.files.first;

  return file;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> writeDocument(String folder, String filename, String content) async {
  final path = await _localPath;
  final file = File('$path/$folder/$filename.txt');

  // Write the file
  return file.writeAsString(content);
}

Future<String> readDocument(String folder, String filename) async {
  try {
    final file = File('$folder/$filename');

    // Read the file
    final contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0
    return 'No se pudo leer el archivo';
  }
}

Future<int> deleteFiles(String folder, List<String> filenames) async {
  try {
    final path = await _localPath;
    for (var filename in filenames) {
      final file = File('$path/$folder/$filename');
      await file.delete();
    }
    return 1;
  } catch (e) {
    return 0;
  }
}

Future<List<String>> getFilesInFolder(String folderPath) async {
  try {
    final files = Directory(folderPath).listSync();

    final filenames = files
        .whereType<File>() // Filtra solo los elementos que son archivos
        .where((file) => file.uri.path.endsWith('.txt')) // Filtra por extensión .txt
        .map((file) => file.uri.pathSegments.last) // Extrae los nombres de archivo
        .toList();

    return filenames;

  } catch (e) {
    print("Error al leer archivos: $e");
    return [];
  }
}

Future<String> createFolderInAppDocDir(String folderName) async {
  //Get this App Document Directory

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  //App Document Directory + folder name
  final Directory appDocDirFolder =
  Directory('${appDocDir.path}/$folderName/');

  if (await appDocDirFolder.exists()) {
    //if folder already exists return path
    return appDocDirFolder.path;
  } else {
    //if folder not exists create folder and then return its path
    final Directory appDocDirNewFolder = await appDocDirFolder.create(recursive: true);
    return appDocDirNewFolder.path;
  }
}
