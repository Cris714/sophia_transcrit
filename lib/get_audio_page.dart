import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/google_auth_service.dart';
import 'package:sophia_transcrit2/view_audio_page.dart';
import 'package:sophia_transcrit2/record_button.dart';

import 'app_provider.dart';
import 'file_manager_s.dart';

class GetAudioPage extends StatefulWidget {
  const GetAudioPage({super.key});

  @override
  State<GetAudioPage> createState() => _GetAudioPage();
}

class _GetAudioPage extends State<GetAudioPage> {

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    GoogleServiceApi.logout();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: true);

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async{
            var files = await pickFiles();
            List<Recording> args = [];
            if (files != null) {
              if (context.mounted) {
                for (var file in files){
                  var filename = file.path;
                  final kb = file.size / 1024;
                  final mb = kb / 1024;
                  final size = (mb >= 1)
                      ? '${mb.toStringAsFixed(2)} MB'
                      : '${kb.toStringAsFixed(2)} KB';
                  args.add(Recording(file, filename!, size));
                }
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
        child: SingleChildScrollView(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: signUserOut,
                  icon: const Icon(Icons.logout, size: 35)
              ),
              const Center(
                child: Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 22)
                ),
              ),
              Center(
                child: Text(
                    appProvider.user == null ? 'HOLLOW' : '${appProvider.user!.email}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                ),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.bottomCenter,
                // padding: const EdgeInsets.only(top: 150),
                child: const RecordButton(),
              ),

            ],
          ),
        )
      )
    );
  }
}
