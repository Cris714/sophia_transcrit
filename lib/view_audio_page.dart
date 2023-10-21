import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/transcriptions_page.dart';

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
        /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TranscriptionsPage()));*/
      });

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
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
                var i = 0;
                () async {
                  for (var rec in record){
                    String filename = rec.path.split('/').last.split('.').first;
                    String file = rec.path.split('/').last;

                    await sendAudio(rec.path);
                    var content = await getTranscription(file);
                    writeDocument('transcriptions',filename, content);
                    // await Future.delayed(const Duration(seconds: 5));
                    await notificationService.showLocalNotification(
                        id: i++,
                        title: "Transcription done!",
                        body: "$file has been transcribed correctly.",
                        payload: ""
                    );
                  }
                }();
                Navigator.pop(context);
                appProvider.setScreen(TranscriptionsPage(), 0);
              },
              child: const Text('Transcribe'),
            ),
          ],
        ),
      ),
    );
  }
}

