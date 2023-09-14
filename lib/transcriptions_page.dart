import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'synthesis_page.dart';
import 'view_text_page.dart';
import 'file_manager_s.dart';
import 'delete_popup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class TranscriptionsPage extends StatefulWidget {
  const TranscriptionsPage({super.key});

  @override
  State<TranscriptionsPage> createState() => _TranscriptionsPage();
}

class _TranscriptionsPage extends State<TranscriptionsPage> {
  List<File> fileList = [];

  _TranscriptionsPage() {
    _getFilesInPath();
  }

  Future<void> _getFilesInPath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dirPath = directory.path;

      final files = Directory(dirPath).listSync();

      setState(() {
        fileList = files.whereType<File>().toList();
      });
    } catch (e) {
      print("Error al leer archivos: $e");
    }
  }

  void _removeItem(int index) {
    setState(() {
      fileList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              IconButton(
                  onPressed: null,
                  icon: Icon(Icons.logout, size: 35)
              ),
              SizedBox(width: 20),
              Center(
                child: Text(
                    "My Transcriptions",
                    style: TextStyle(fontSize: 20)
                ),
              ),
            ]
          ),
          const Divider(),
          // const SizedBox(height: 400),
          /*ElevatedButton(
              onPressed: () async {
                var content = await getTranscription();
                writeDocument('test_transcription', content);
              },
              child: const Text('(temp)')
          ),*/

          // Lista de archivos transcritos
          Expanded(
            child: ListView.builder(
              itemCount: fileList.length,
              itemBuilder: (context, index) {
                final file = fileList[index];
                final filename = path.basename(file.path);
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.file_present_rounded),
                      title: Text(filename),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteConfirmationDialog(
                                onConfirm: () {
                                  deleteFile(filename);
                                  _removeItem(index);
                                },
                              );
                            },
                          );
                        },
                      ),
                      onTap: () {
                        // Navegar a la nueva página cuando se presiona un elemento
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewText(filename: filename)),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),

          ElevatedButton(
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SynthesisPage()),
                  );
                },
              child: const Text('Process')
          ),

        ],
      ),
    );
  }
}