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
  final Recording record;

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
              // child: Text(
              //   todo.path,
              //   style: const TextStyle(fontSize: 17)
              // )

              // child: Column(
              //   children: [
              //     Text('Name:  ${todo.file.name}'),
              //     Text('Size:  ${todo.size!}'),
              //     Text('Extension:  ${todo.file!.extension}')
              //   ],
              // ),

              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  itemCount: 1,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(record.file.name),
                      subtitle: Text(record.file.extension ?? ""),
                      trailing: Text(record.size),

                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 8.0),
              onPressed: () {
                null;
              },
              child: const Text('Generate document'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 8.0),
              onPressed: () {
                String filename = record.path.split('/').last.split('.').first;
                String file = record.path.split('/').last;
                () async {
                  await sendAudio(record.path);
                  var content = await getTranscription(file);
                  writeDocument('transcriptions',filename, content);
                }();
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

