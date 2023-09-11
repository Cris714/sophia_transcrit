import 'package:flutter/material.dart';

import 'requests_manager.dart';
import 'file_manager_s.dart';

class SynthesisPage extends StatefulWidget {
  const SynthesisPage({super.key});

  @override
  State<SynthesisPage> createState() => _SynthesisPage();
}

class _SynthesisPage extends State<SynthesisPage> {
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
              ]
            ),
            const Center(
              child: Text(
                "What's next?",
                style: TextStyle(fontSize: 30)
              ),
            ),
            const Center(
              child: Text(
                "Generate your document",
                style: TextStyle(fontSize: 17)
              ),
            ),
            const SizedBox(height: 50),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Key words",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                SizedBox(width: 30),
                Switch(
                    value: true,
                    onChanged: null
                )
              ]
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                SizedBox(width: 30),
                Switch(
                    value: true,
                    onChanged: null
                )
              ]
            ),
            const SizedBox(height: 380),
            ElevatedButton(
              onPressed: () async {
                sendText('test_transcription');
                var content = await getProcessedContent('test_transcription');
                writeDocument('test_process', content);
                // readTranscription();
              },
              child: const Text('Done'))

          ],
        ),
      ),
    );
  }
}