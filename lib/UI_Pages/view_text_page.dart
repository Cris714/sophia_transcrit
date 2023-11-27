import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../Managers/file_manager_s.dart';

class ViewText extends StatelessWidget {
  final String filename;
  final String folder;
  const ViewText({super.key, required this.filename, required this.folder});

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
                  Expanded( // Envuelve el Text con Expanded
                    child: Center(
                      child: Text(
                        filename,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        Share.shareXFiles([XFile('$folder/$filename')],
                              text: "Check out this transcription I've made!");
                      },
                      icon: const Icon(Icons.share, size: 35)
                  ),
                ]
            ),
            const Divider(),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: FutureBuilder<String>(
                future: readDocument(folder, filename),
                builder: (context, snapshot) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 140,
                    child: SingleChildScrollView(
                      child: Text(
                          snapshot.data ?? "Loading...",
                          style: const TextStyle(fontSize: 17)
                      ),
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



