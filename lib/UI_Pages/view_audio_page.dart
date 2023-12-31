import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/UI_Pages/transcriptions_page.dart';

import '../Managers/app_provider.dart';
import '../Managers/requests_manager.dart';

class Recording {
  final PlatformFile file;
  final String path;
  final String size;

  const Recording(this.file, this.path, this.size);
}

class ViewAudio extends StatefulWidget {
  const ViewAudio({super.key, required this.record});
  final List<Recording> record;

  @override
  State<ViewAudio> createState() => _ViewAudio();
}

class _ViewAudio extends State<ViewAudio> {
  late List<Recording> record;
  late AppProvider _appProvider;
  int countError = 0;
  final audioPlayer = AudioPlayer();
  int playIndex = -1;

  @override
  void initState() {
    record = widget.record;

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playRecording(audioPath) async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      debugPrint("Error playing record: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      debugPrint("Error stopping record: $e");
    }
  }

  void togglePlay(int index) {
    if (index == playIndex) {
      stopRecording();
      setState(() {
        playIndex = -1;
      });
    } else {
      playRecording(record[index].file.path);
      setState(() {
        playIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        playIndex = -1;
      });
    });
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
                  const SizedBox(width: 20),
                  const Center(
                    child: Text(
                        "Recording info",
                        style: TextStyle(fontSize: 20)
                    ),
                  ),
                ]
            ),
            const Divider(),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),

              child: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 200,
                child: ListView.separated(
                  itemCount: record.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(record[index].file.name),
                      subtitle: Text(record[index].file.extension ?? ""),
                      leading: IconButton(
                          onPressed: () {
                            togglePlay(index);
                          },
                          icon: playIndex != index ? const Icon(Icons
                              .play_arrow, size: 35) : const Icon(Icons.pause,
                              size: 35)
                      ),
                      trailing: Text(record[index].size),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 8.0),
              onPressed: () {
                () async {
                  for (var rec in record) {
                    await sendAudio(rec.path);
                  }
                }
                ();
                Navigator.pop(context);
                _appProvider.setScreen(const TranscriptionsPage(), 0);
                _appProvider.setShowCardTrans(true);
              },
              child: const Text('Transcribe'),
            ),
          ],
        ),
      ),
    );
  }
}