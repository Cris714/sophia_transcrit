import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sophia_transcrit2/Styles/colors.dart';
import 'package:record/record.dart';
import 'package:sophia_transcrit2/Managers/requests_manager.dart';
import 'package:sophia_transcrit2/UI_Pages/transcriptions_page.dart';
import 'package:audioplayers/audioplayers.dart';

import '../Notification/notification_service.dart';
import '../Managers/app_provider.dart';
import '../Managers/file_manager_s.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  final duration = const Duration(milliseconds: 300);
  String recordingTime = '00:00';
  int time = 0;
  Timer? timer;

  var isRecording = false;
  var isSaving = false;
  var pause = false;
  late int counter;
  late String dirPath;
  late TextEditingController nameController;
  late AppProvider _appProvider;
  final record = AudioRecorder();
  static dynamic staticRecord;
  final audioPlayer = AudioPlayer();
  String audioPath = "";
  int countError = 0;

  void getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt('audioCounter') ?? 0);
      dirPath = (prefs.getString('dirPath') ?? "");
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
    var dir = await selectExternalDirectory();
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
    record.dispose();
    super.dispose();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 60),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        )
    );
  }

  void recordTime() {
    // var startTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      // var diff = DateTime.now().difference(startTime);
      time++;
      recordingTime = '${(time / 3600).floor() == 0 ? '' : '${(time / 3600).floor().toString().padLeft(2,
          "0")}:'}${((time / 60).floor() % 60).toString().padLeft(2,
          "0")}:${(time % 60).toString().padLeft(2, '0')}';
      // recordingTime =
      // '${diff.inHours == 0 ? '' : diff.inHours.toString().padLeft(2,
      //     "0") + ':'}${(diff.inMinutes % 60).floor().toString().padLeft(2,
      //     "0")}:${(diff.inSeconds % 60).floor().toString().padLeft(2, '0')}';
      setState(() {});
    });
  }

  void stopTime() {
    timer?.cancel();
  }

  static Future<void> xd(a) async {
    await staticRecord.pause();
    print('aaa');
    return Future.value();
  }

  void startRecording() async {
    try {
      if (await record.hasPermission()) {
        recordTime();
        nameController = TextEditingController(text: 'audio$counter');
        var dir = await createFolderInAppDocDir("recordings");
        await record.start(const RecordConfig(), path: '$dir/audio.m4a');
        setState(() {
          isRecording = true;
        });
        staticRecord = record;
        NotificationController.startListeningNotificationEvents(xd);
        NotificationController.createNewNotification();
      }
    } catch(e){
      debugPrint("Error starting record: $e");
    }
  }

  void pauseRecording() async {
    try {
      await record.pause();
      stopTime();
      setState(() {
        pause = true;
      });
    } catch(e) {
      debugPrint("Error pausing record: $e");
    }
  }

  void resumeRecording() async {
    try {
      await record.resume();
      recordTime();
      setState(() {
        pause = false;
      });
    } catch(e) {
      debugPrint("Error resuming record: $e");
    }
  }

  void stopRecording() async {
    try {
      final path = await record.stop();
      await NotificationController.dismissRecordingNotification();
      stopTime();
      if(dirPath == "") {
        setDirPath();
      }
      setState(() {
        isRecording = false;
        pause = false;
        isSaving = true;
        audioPath = path!;
        recordingTime = '00:00';
        time = 0;
      });
    } catch(e) {
      debugPrint("Error stopping record: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    _appProvider = Provider.of<AppProvider>(context, listen: true);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // if(isRecording && !pause) RecordWaves(
            //   duration: duration,
            //   size: width,
            // ),
            AnimatedContainer(
              width: width,
              height: width,
              duration: duration,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: isRecording ? sophiasecondaryred : Colors.grey,
                    width: isRecording ? 4 : 1,
                  ),
                  borderRadius: BorderRadius.circular(width)
              ),
              child: tapButton(width),
            ),
            if(isRecording) Text(recordingTime),

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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width/2, // Establece un ancho máximo para el contenedor
                          child: Text(
                            dirPath,
                            maxLines: 5, // Establece un máximo de 1 línea
                            overflow: TextOverflow.ellipsis, // Agrega puntos suspensivos en caso de desbordamiento
                            style: const TextStyle(
                              fontSize: 13, // Establece el tamaño de fuente a 20 puntos
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: setDirPath,
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
                    showMessage('Audio file has been discarded');
                    setState(() {
                      isSaving = false;
                    });
                  },
                  child: const Text('Discard'),
                ),
                TextButton(
                  onPressed: () async{
                    var status = await Permission.manageExternalStorage.request();
                    if(dirPath == "") {
                      setDirPath();
                    }
                    if(status.isGranted && dirPath != "" && nameController.text != ""){
                      await saveAudioFile(dirPath, nameController.text, audioPath);
                      _incrementCounter();
                      showMessage('Audio file saved successfully');
                      setState(() {
                        isSaving = false;
                      });
                    }
                  },
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () async{
                    var status = await Permission.manageExternalStorage.request();
                    if(dirPath == "") {
                      setDirPath();
                    }
                    if(status.isGranted && dirPath != "" && nameController.text != ""){
                      await saveAudioFile(dirPath, nameController.text, audioPath);
                      _incrementCounter();
                      sendAudio("$dirPath/${nameController.text}.m4a");
                      _appProvider.setShowCardTrans(true);
                      _appProvider.setScreen(const TranscriptionsPage(), 0);
                      setState(() {
                        isSaving = false;
                      });
                    }
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
        ),

        // AnimatedOpacity(
        //   duration: const Duration(seconds: 2),
        //   opacity: _appProvider.showCardAudio ? 1.0 : 0.0, // Controla la opacidad
        //   child: const Card(
        //     elevation: 4,
        //     margin: EdgeInsets.all(16),
        //     child: Padding(
        //       padding: EdgeInsets.all(16),
        //       child: Text(
        //         'Audio file copied successfully',
        //         style: TextStyle(
        //           fontSize: 13,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

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
            color: sophiasecondaryred,
            borderRadius: BorderRadius.circular(
              isRecording ? 20 : 80,
            ),
            boxShadow: [
              BoxShadow(
                color: sophiasecondaryred.withOpacity(0.4),
                blurRadius: isRecording ? 17.5 : 40.0,
                spreadRadius: isRecording ? 7.5 : 20.0,
              )
            ],
          ),
          child: null,
        ),
      ),
  );

  /*void _startBackgroundTask() async {
    await Isolate.spawn(_backgroundTask, [_port.sendPort, dirPath, nameController.text]);
    _port.listen((message) {
      var msg;
      if(message[3] == 200){
        msg = "Tap to continue.";
        writeDocument('transcriptions',message[1], message[2]);
      } else {
        countError = countError + 1;
        _appProvider.addError(ErrorItem("${message[1]}.txt", message[3]));
        msg = "$countError error found.";
      }
      // Handle background task completion
      if (message[0] == 1) {
        notificationService.showLocalNotification(
            id: 0,
            title: "Your transcription is ready!",
            payload: "", body: msg,
        );
        if(countError != 0){
          _appProvider.setShowErrors(true);
        }
        countError = 0;
      }
      _appProvider.getTranscriptions();
    });
    notificationService.showLocalNotification(
        id: 0,
        title: "Transcribing file...",
        payload: "", body: '',
    );
  }

  static void _backgroundTask(List<dynamic> args) {
    var i = 1;
    SendPort sendPort = args[0];
    String dir = args[1];
    String filename = args[2];
    String file = "$filename.m4a";
    () async {
      try {
        await sendAudio("$dir/$file");
        var response = await getTranscription(file);
        var content = response.body;
        // writeDocument('transcriptions',filename, content);
        // await Future.delayed(const Duration(seconds: 5));
        // Send result back to the main UI isolate
        sendPort.send([i++, filename, content, response.statusCode]);
      } catch (e) {
        sendPort.send([i++, filename, "error", 0]);
      }
    }();
  }*/

}
