import 'package:flutter/material.dart';
import 'package:sophia_transcrit2/view_audio_page.dart';

import 'file_manager_s.dart';

class GetAudioPage extends StatefulWidget {
  const GetAudioPage({super.key});

  @override
  State<GetAudioPage> createState() => _GetAudioPage();
}

class _GetAudioPage extends State<GetAudioPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              SizedBox(width: 20),
              IconButton(
                  onPressed: null,
                  icon: Icon(Icons.logout, size: 35)
              ),
            ]
          ),
          const Center(
            child: Text(
                "Welcome Back",
                style: TextStyle(fontSize: 22)
            ),
          ),
          const Center(
            child: Text(
              "HOLLOW",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(top: 150),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 8.0),
                  onPressed: null,
                  child: const Text('Start Recording'),
                ),
                ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 8.0),
                //onPressed: openFileManager(),
                onPressed: () async {
                  var filename = await pickFile();
                  if (filename != '') {
                    if (context.mounted) {
                      final args = Todo(filename);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAudio(todo: args),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Import Audio')
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
