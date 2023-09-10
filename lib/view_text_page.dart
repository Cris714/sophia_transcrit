import 'package:flutter/material.dart';

import 'file_manager_s.dart';

class ViewText extends StatefulWidget {
  const ViewText({super.key});

  @override
  State<ViewText> createState() => _ViewText();
}

class _ViewText extends State<ViewText> {
  Future<void> computeFuture = Future.value();

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
                        "test_transcription",
                        style: TextStyle(fontSize: 20)
                    ),
                  ),
                ]
            ),
            const Divider(),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: FutureBuilder<String>(
                future: readDocument('test_process'),
                builder: (context, snapshot) {
                  return Text(
                      snapshot.data ?? "Loading...",
                      style: const TextStyle(fontSize: 17)
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



