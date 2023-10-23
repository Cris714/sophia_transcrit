import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/transcriptions_page.dart';
import 'dart:isolate';

import 'home.dart';
import 'requests_manager.dart';
import 'file_manager_s.dart';
import 'notification_service.dart';

class Recording {
  final PlatformFile file;
  final String path;
  final String size;

  const Recording(this.file, this.path, this.size);
}

class ViewAudio extends StatefulWidget {
  const ViewAudio({super.key, required this.record});
  final List<Recording> record;

  @override
  State<ViewAudio> createState() => _ViewAudio();
}

class _ViewAudio extends State<ViewAudio> {
  late List<Recording> record;
  late final NotificationService notificationService;
  final ReceivePort _port = ReceivePort();
  late AppProvider _appProvider;
  int countError = 0;

  @override
  void initState() {
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    record = widget.record;

    super.initState();
  }

  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        _appProvider.setScreen(const TranscriptionsPage(), 0);
      });

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 40, 15, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.home, size: 35)
                  ),
                  const SizedBox(width: 20),
                  const Center(
                    child: Text(
                        "Recording info",
                        style: TextStyle(fontSize: 20)
                    ),
                  ),
                ]
            ),
            const Divider(),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),

              child: SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: ListView.separated(
                  itemCount: record.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(record[index].file.name),
                      subtitle: Text(record[index].file.extension ?? ""),
                      trailing: Text(record[index].size),

                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 8.0),
              onPressed: () {
                _startBackgroundTask();
                Navigator.pop(context);
                _appProvider.setScreen(const TranscriptionsPage(), 0);
                _appProvider.setShowCardTrans(true);
              },
              child: const Text('Transcribe'),
            ),
          ],
        ),
      ),
    );
  }

  void _startBackgroundTask() async {
    await Isolate.spawn(_backgroundTask, [_port.sendPort, record]);
    _port.listen((message) {
      var msg;
      if(message[3] == 200){
        msg = "${message[0]}/${record.length} done.";
      } else {
        countError = countError + 1;
        _appProvider.addError("${message[1]}.txt");
        if(countError == 1) {
          msg = "${message[0]}/${record.length} done. $countError error found.";
        } else {
          msg = "${message[0]}/${record.length} done. $countError errors found.";
        }
      }
      // Handle background task completion
      if (message[0] != record.length) {
        notificationService.showLocalNotification(
            id: 0,
            title: "Transcribing files...",
            body: msg,
            payload: ""
        );
      }
      else{
        notificationService.showLocalNotification(
            id: 0,
            title: "Your transcriptions are ready!",
            body: msg,
            payload: ""
        );
        if(countError != 0){
          _appProvider.setShowErrors(true);
        }
        countError = 0;
      }
      writeDocument('transcriptions',message[1], message[2]);
      _appProvider.addTranscription('${message[1]}.txt');
    });
    notificationService.showLocalNotification(
        id: 0,
        title: "Transcribing files...",
        body: "0/${record.length} done.",
        payload: ""
    );
  }

  static void _backgroundTask(List<dynamic> args) {
    var i = 1;
    SendPort sendPort = args[0];
    List<Recording> record = args[1];
    () async {
      for (var rec in record){
        String filename = rec.path.split('/').last.split('.').first;
        String file = rec.path.split('/').last;

        await sendAudio(rec.path);
        var response = await getTranscription(file);
        var content = response.body;
        // writeDocument('transcriptions',filename, content);
        // await Future.delayed(const Duration(seconds: 5));
        // Send result back to the main UI isolate
        sendPort.send([i++, filename, content, response.statusCode]);
      }
    }();
  }
}

