import 'package:flutter/material.dart';
import 'package:sophia_transcrit2/view_audio_page.dart';
import 'package:sophia_transcrit2/record_button.dart';

import 'file_manager_s.dart';

class GetAudioPage extends StatefulWidget {
  const GetAudioPage({super.key});

  @override
  State<GetAudioPage> createState() => _GetAudioPage();
}

class _GetAudioPage extends State<GetAudioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async{
            var file = await pickFile();
            if (file != null) {
              if (context.mounted) {
                var filename = file.path;
                final kb = file.size / 1024;
                final mb = kb / 1024;
                final size = (mb >= 1)
                    ? '${mb.toStringAsFixed(2)} MB'
                    : '${kb.toStringAsFixed(2)} KB';
                final args = Recording(file, filename!, size);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewAudio(record: args),
                  ),
                );
              }
            }
          },
          label: const Text('Import Audio'),
          icon: const Icon(Icons.drive_folder_upload),

        ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

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
              child: const RecordButton(),
            ),
          ],
        ),
      )
    );
  }
}
