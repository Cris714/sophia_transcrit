import 'package:flutter/material.dart';

import 'file_manager_s.dart';

class GetAudioPage extends StatefulWidget {
  const GetAudioPage({super.key});

  @override
  State<GetAudioPage> createState() => _GetAudioPage();
}

class _GetAudioPage extends State<GetAudioPage> {
  Future<void> computeFuture = Future.value();

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
                  pickFile();
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
