import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:open_file/open_file.dart';

class GetAudioPage extends StatefulWidget {
  const GetAudioPage({super.key});

  @override
  State<GetAudioPage> createState() => _GetAudioPage();
}

class _GetAudioPage extends State<GetAudioPage> {
  Future<void> computeFuture = Future.value();

  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // if no file is picked
    if (result == null) return;

    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    /*print(result.files.first.name);
    print(result.files.first.size);
    print(result.files.first.path);*/
  }

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
                FutureBuilder(
                  future: computeFuture,
                  builder: (context, snapshot) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 8.0),
                      onPressed: null,
                      child: const Text('Start Recording'),
                    );
                  },
                ),
                ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 8.0),
                //onPressed: openFileManager(),
                onPressed: () {
                  _pickFile();
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
