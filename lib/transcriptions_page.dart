import 'package:flutter/material.dart';

import 'synthesis_page.dart';

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
          const SizedBox(height: 550),
          ElevatedButton(
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SynthesisPage()),
                  );
                },
              child: const Text('Process'))

        ],
      ),
    );
  }
}
