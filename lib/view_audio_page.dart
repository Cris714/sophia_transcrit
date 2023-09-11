import 'package:flutter/material.dart';
import 'requests_manager.dart';

class Todo {
  final String filename;

  const Todo(this.filename);
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
                        "test_audio",
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
                todo.filename,
                style: const TextStyle(fontSize: 17)
              )
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 8.0),
              onPressed: () async {
                sendAudio(todo.filename);
              },
              child: const Text('Transcribe'),
            ),
          ],
        ),
      ),
    );
  }
}

