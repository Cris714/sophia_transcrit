import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'requests_manager.dart';
import 'file_manager_s.dart';

class Recording {
  final PlatformFile file;
  final String path;
  final String size;

  const Recording(this.file, this.path, this.size);
}

class ViewAudio extends StatelessWidget {
  const ViewAudio({super.key, required this.record});
  final List<Recording> record;

  @override
  Widget build(BuildContext context) {
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
                height: 200,
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
                for (var rec in record){
                  String filename = rec.path.split('/').last.split('.').first;
                  String file = rec.path.split('/').last;
                  () async {
                    await sendAudio(rec.path);
                    var content = await getTranscription(file);
                    writeDocument('transcriptions',filename, content);
                  }();
                }
                Navigator.pop(context);
              },
              child: const Text('Transcribe'),
            ),
          ],
        ),
      ),
    );
  }
}

