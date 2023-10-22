import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';

const address = 'http://146.83.216.166/api2';

Future getTranscription(String query) async {
  http.Response response = await http.get(
      Uri.parse('$address/transcript?File=$query'));
  return response.body;
}

Future getProcessedContent(List<String> query, List<String> req) async {
  http.Response response = await http.get(
      Uri.parse('$address/process?File=$query&Req=${req.join(",,,")}'));
  return response.body;
}


sendText(String path) async {
  http.MultipartRequest request = http.MultipartRequest('POST',
      Uri.parse('$address/text'));

  print(File(path).path);

  request.files.add(
    await http.MultipartFile.fromPath(
      'text',
      File(path).path,
      contentType: MediaType('application', 'txt'),
    ),
  );

  http.StreamedResponse r = await request.send();
  print(r.statusCode);
  // print(await r.stream.transform(utf8.decoder).join());
}

sendAudio(String path) async {
  http.MultipartRequest request = http.MultipartRequest('POST',
      Uri.parse('$address/audio'));

  request.files.add(
    await http.MultipartFile.fromPath(
      'audio',
      File(path).path,
      contentType: MediaType('application', 'mp3'),
    ),
  );

  http.StreamedResponse r = await request.send();
  print(r.statusCode);
  // print(await r.stream.transform(utf8.decoder).join());
}