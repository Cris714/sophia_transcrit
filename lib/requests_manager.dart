import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';

import 'file_manager_s.dart';

const address = 'http://146.83.216.166/api2';
//  const address = 'http://172.17.32.254:5006';

Future<String> getUserTokenId() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final idToken = await auth.currentUser?.getIdToken();

  return idToken!;
}

// Future getTranscription(String query) async {
//   String userId = await getUserTokenId();
//
//   http.Response response = await http.get(
//       Uri.parse('$address/transcript/$userId?File=$query'));
//
//   return response;
// }

Future getTranscription() async {
  String userId = await getUserTokenId();

  http.Response response = await http.get(
      Uri.parse('$address/transcripts/$userId'));

  Map<String, dynamic> data = jsonDecode(response.body);

  data.forEach((key, value) {writeDocument('transcriptions', key, value);});
}

Future getProcessedContent(List<String> query, List<String> req) async {
  String userId = await getUserTokenId();

  http.Response response = await http.put(
      Uri.parse('$address/process/$userId?File=$query&Req=${req.join(",,,")}'));

  return response;
}


sendText(String path) async {
  String userId = await getUserTokenId();

  http.MultipartRequest request = http.MultipartRequest('POST',
      Uri.parse('$address/text/$userId'));

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
  String userId = await getUserTokenId();

  http.MultipartRequest request = http.MultipartRequest('POST',
      Uri.parse('$address/audio/$userId'));

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

registerUser() async {
  String userId = await getUserTokenId();

  http.Response response = await http.get(
      Uri.parse('$address/register/$userId'));

  print(response.statusCode);
}

updateTokenNotification() async {
  final notifToken = await FirebaseMessaging.instance.getToken();

  String userId = await getUserTokenId();

  http.MultipartRequest request = http.MultipartRequest('PUT',
      Uri.parse('$address/notifications/$userId?token=$notifToken'));

  http.StreamedResponse r = await request.send();

  print(r.statusCode);
}

deleteFilesSV(List<String> filenames, String type) async {
  String userId = await getUserTokenId();

  final data = jsonEncode(filenames.map((e) => e).toList());

  http.MultipartRequest request = http.MultipartRequest('DELETE',
      Uri.parse('$address/delete/$userId?Files=$data&Type=$type'));

  http.StreamedResponse r = await request.send();

  print(r.statusCode);
}