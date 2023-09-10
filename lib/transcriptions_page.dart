import 'package:flutter/material.dart';

import 'synthesis_page.dart';
import 'requests_manager.dart';
import 'file_manager_s.dart';

class TranscriptionsPage extends StatefulWidget {
  const TranscriptionsPage({super.key});

  @override
  State<TranscriptionsPage> createState() => _TranscriptionsPage();
}

class _TranscriptionsPage extends State<TranscriptionsPage> {
  Future<void> computeFuture = Future.value();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              IconButton(
                  onPressed: null,
                  icon: Icon(Icons.logout, size: 35)
              ),
              SizedBox(width: 20),
              Center(
                child: Text(
                    "My Transcriptions",
                    style: TextStyle(fontSize: 20)
                ),
              ),
            ]
          ),
          const Divider(),
          const SizedBox(height: 400),
          ElevatedButton(
              onPressed: () async {
                var content = await getTranscription();
                writeDocument('test_transcription', content);
              },
              child: const Text('(temp)')
          ),
          ElevatedButton(
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SynthesisPage()),
                  );
                },
              child: const Text('Process')
          )
        ],
      ),
    );
  }
}