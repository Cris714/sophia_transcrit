import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/documents_page.dart';

import 'home.dart';
import 'requests_manager.dart';
import 'file_manager_s.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SynthesisPage extends StatefulWidget {
  final String folder;
  final List<String> pathList;
  const SynthesisPage({super.key, required this.folder, required this.pathList});

  @override
  State<SynthesisPage> createState() => _SynthesisPage();
}

class _SynthesisPage extends State<SynthesisPage> {

  late String folder;
  late List<String> pathList;
  String documentFolder = "documents";
  late int counter;
  late AppProvider _appProvider;

  @override
  void initState() {
    getSharedPref();

    super.initState();
    folder = widget
        .folder;
    pathList = widget
        .pathList;
    _appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  void getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt('counter') ?? 0);
    });
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final c = (prefs.getInt('counter') ?? 0)+1;
    counter = c;
    prefs.setInt('counter', counter);
  }

  Future<void> computeFuture = Future.value();
  bool keySelected = false;
  bool sumSelected = true;

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
                      icon: const Icon(Icons.arrow_back, size: 35)
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
                  'Generate your document.',
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
                  if(sumSelected || keySelected){
                    () async {
                      for (var file in pathList){
                        await sendText('$folder/$file');
                      }

                      var content = await getProcessedContent(pathList, keySelected, sumSelected);

                      writeDocument('documents', 'document$counter', content);
                      // Save an integer value to 'counter' key.
                      _incrementCounter();

                    }();
                    Navigator.pop(context);
                    _appProvider.setScreen(DocumentsPage(), 2);
                  }
                },
                child: const Text('Done'))

          ],
        ),
      ),
    );
  }
}