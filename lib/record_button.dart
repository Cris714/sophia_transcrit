import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sophia_transcrit2/record_waves.dart';
import 'package:sophia_transcrit2/transcriptions_page.dart';

import 'home.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  final duration = const Duration(milliseconds: 300);

  var isRecording = false;
  var isSaving = false;
  late int counter;
  late TextEditingController nameController;
  late AppProvider _appProvider;

  void getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt('audioCounter') ?? 0);
      nameController = TextEditingController(text: 'audio$counter');
    });
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final c = (prefs.getInt('audioCounter') ?? 0)+1;
    counter = c;
    prefs.setInt('audioCounter', counter);
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    return Stack(
      alignment: Alignment.center,
      children: [
        if(isRecording) RecordWaves(
          duration: duration,
          size: width,
        ),
        AnimatedContainer(
          width: width,
          height: width,
          duration: duration,
          decoration: BoxDecoration(
            border: Border.all(
              color: isRecording ? Colors.red : Colors.grey,
              width: isRecording ? 4 : 1,
            ),
            borderRadius: BorderRadius.circular(width)
          ),
          child: tapButton(width),
        ),

        if(isSaving) AlertDialog(
          title: const Text("Save Recording"),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TextField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  controller: nameController
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ruta/del/archivo"),
                    IconButton(
                        onPressed: null,
                        icon: const Icon(Icons.file_present_rounded, size: 35)
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isSaving = false;
                });
              },
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isSaving = false;
                });
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isSaving = false;
                  _appProvider.setScreen(const TranscriptionsPage(),0);
                });
              },
              child: const Text('Save & transcript'),
            ),
          ],
        )

      ]
    );
  }

  Widget tapButton(double size) => Center(
      child: GestureDetector(
        onTap: () => setState(() {
          isRecording = !isRecording;
          if(!isRecording) {
            isSaving = true;
          }
        }),
        child: AnimatedContainer(
          duration: duration,
          width: isRecording ? size * 0.65 - 30 : size * 0.65,
          height: isRecording ? size * 0.65 - 30 : size * 0.65,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: isRecording ? 4 : 8,
            ),
            color: Colors.red,
            borderRadius: BorderRadius.circular(
              isRecording ? 20 : 80,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.4),
                blurRadius: isRecording ? 17.5 : 40.0,
                spreadRadius: isRecording ? 7.5 : 20.0,
              )
            ],
          ),
          child: Center(
            child: Text(isRecording ? 'STOP' : 'RECORD'),
          ),
        ),
      ),
  );
}
