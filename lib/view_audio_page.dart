import 'package:flutter/material.dart';

import 'requests_manager.dart';
import 'file_manager_s.dart';

class Todo {
  final String path;

  const Todo(this.path);
}


class ViewAudio extends StatelessWidget {
  const ViewAudio({super.key, required this.todo});
  final Todo todo;

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
              child: Text(
                todo.path,
                style: const TextStyle(fontSize: 17)
              )
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
                String filename = todo.path.split('/').last.split('.').first;
                String file = todo.path.split('/').last;
                print(file);
                () async {
                  await sendAudio(todo.path);
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

