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
  bool keySelected = false;
  bool sumSelected = false;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Key words",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                const SizedBox(width: 30),
                Switch(
                  value: keySelected,
                  onChanged: (value) {
                    setState(() {
                      keySelected = value;
                    });
                  },
                ),
              ]
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                SizedBox(width: 30),
                Switch(
                  value: sumSelected,
                  onChanged: (value) {
                    setState(() {
                      sumSelected = value;
                    });
                  },
                ),
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