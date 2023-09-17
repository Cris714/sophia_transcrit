import 'package:flutter/material.dart';

import 'requests_manager.dart';
import 'file_manager_s.dart';

class SynthesisPage extends StatefulWidget {
  final String path;
  const SynthesisPage({super.key, required this.path});

  @override
  State<SynthesisPage> createState() => _SynthesisPage();
}

class _SynthesisPage extends State<SynthesisPage> {

  late String path;
  late String text;

  @override
  void initState() {
    super.initState();
    path = widget
        .path; // Inicializa 'file' con el valor proporcionado en el widget
    text = path.split('/').last.split('.').first;
  }

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
            Center(
              child: Text(
                  'Generate your document. $text',
                  style: TextStyle(fontSize: 17)
              ),
            ),
            const SizedBox(height: 50),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      "Key words",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)
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
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(width: 30),
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
                onPressed: () {
                  String filename = path.split('/').last.split('.').first;
                  String file = path.split('/').last;
                  () async {
                    await sendText(path);
                    var content = await getProcessedContent(file, keySelected, sumSelected);
                    writeDocument('documents', filename, content);
                  }();
                  Navigator.pop(context);
                },
                child: const Text('Done'))

          ],
        ),
      ),
    );
  }
}