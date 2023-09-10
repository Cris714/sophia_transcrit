import 'package:flutter/material.dart';

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
            const SizedBox(height: 550),
            const ElevatedButton(
                onPressed: null,
                child: Text('Done'))

          ],
        ),
      ),
    );
  }
}