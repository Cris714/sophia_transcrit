import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sophia_transcrit2/record_waves.dart';
import 'package:record/record.dart';
import 'package:sophia_transcrit2/view_audio_page.dart';
import 'package:audioplayers/audioplayers.dart';

import 'file_manager_s.dart';
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
  var pause = false;
  late int counter;
  late String dirPath;
  late TextEditingController nameController;
  late AppProvider _appProvider;
  final record = AudioRecorder();
  final audioPlayer = AudioPlayer();
  String audioPath = "";

  void getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt('audioCounter') ?? 0);
      dirPath = (prefs.getString('dirPath') ?? "");
      nameController = TextEditingController(text: 'audio$counter');
    });
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final c = (prefs.getInt('audioCounter') ?? 0)+1;
    counter = c;
    prefs.setInt('audioCounter', counter);
  }

  void setDirPath() async {
    final prefs = await SharedPreferences.getInstance();
    var dir = (await selectExternalDirectory())!;
    setState(() {
      dirPath = dir;
    });
    prefs.setString('dirPath', dirPath);
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  @override
  void dispose(){
    audioPlayer.dispose();
    record.dispose();
    super.dispose();
  }

  void startRecording() async {
    try {
      if (await record.hasPermission()) {
        var path = await createFolderInAppDocDir("recordings");

        await record.start(const RecordConfig(), path: '$path/audio.m4a');
        setState(() {
          isRecording = true;
        });
      }
    } catch(e){
      print("Error starting record: $e");
    }
  }

  void pauseRecording() async {
    try {
      await record.pause();
      setState(() {
        pause = true;
      });
    } catch(e) {
      print("Error pausing record: $e");
    }
  }

  void resumeRecording() async {
    try {
      await record.resume();
      setState(() {
        pause = false;
      });
    } catch(e) {
      print("Error resuming record: $e");
    }
  }

  void stopRecording() async {
    try {
      final path = await record.stop();
      setState(() {
        isRecording = false;
        pause = false;
        isSaving = true;
        audioPath = path!;
      });
    } catch(e) {
      print("Error stopping record: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch(e) {
      print("Error playing record: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if(isRecording && !pause) RecordWaves(
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
                            onPressed: playRecording,
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
                      if(dirPath == "") {
                        setDirPath();
                      }
                      saveAudioFile(dirPath, audioPath);
                      _incrementCounter();
                    });
                  },
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isSaving = false;
                      // _appProvider.setScreen(const TranscriptionsPage(),0);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAudio(record: [Recording(PlatformFile(path: audioPath, name: 'audioPrueba.m4a', size: 300), audioPath, "300 MB")]),
                        ),
                      );
                    });
                  },
                  child: const Text('Save & transcript'),
                ),
              ],
            )

          ]
        ),

        if(isRecording) Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: !pause ? pauseRecording : resumeRecording,
                icon: !pause ? const Icon(Icons.pause, size: 35) : const Icon(Icons.play_arrow, size: 35)
            ),
            IconButton(
                onPressed: stopRecording,
                icon: const Icon(Icons.stop, size: 35)
            ),
          ],
        )

      ],
    );
  }

  Widget tapButton(double size) => Center(
      child: GestureDetector(
        onTap: () {
          if(!isRecording){
            startRecording();
          }
        },
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
          child: null,
        ),
      ),
  );
}
