import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future getTranscription() async {
  http.Response response = await http.get(
      Uri.parse('http://192.168.1.4:8000/transcript'));
  return response.body;
}

Future getProcessedContent(String query) async {
  http.Response response = await http.get(
      Uri.parse('http://192.168.1.4:8000/process?File=$query'));
  return response.body;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

sendFile(String filename) async {
  http.MultipartRequest request = http.MultipartRequest('POST',
      Uri.parse('http://192.168.1.4:8000/test'));

  final path = await _localPath;

  request.files.add(
    await http.MultipartFile.fromPath(
      'text',
      File('$path/$filename.txt').path,
      contentType: MediaType('application', 'txt'),
    ),
  );

  http.StreamedResponse r = await request.send();
  print(r.statusCode);
  // print(await r.stream.transform(utf8.decoder).join());
}