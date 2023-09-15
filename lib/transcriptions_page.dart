import 'dart:async';

import 'package:flutter/material.dart';

import 'synthesis_page.dart';
import 'view_text_page.dart';
import 'file_manager_s.dart';
import 'delete_popup.dart';

class TranscriptionsPage extends StatefulWidget {
  const TranscriptionsPage({super.key});

  @override
  State<TranscriptionsPage> createState() => _TranscriptionsPage();
}

class _TranscriptionsPage extends State<TranscriptionsPage> {
  List<String> fileList = [];

  @override
  void initState() {
    super.initState();
    _getFilesInPath();
  }

  Future<void> _getFilesInPath() async {
    try {
      final filenames = await getFilesInPath();

      setState(() {
        fileList = filenames;
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

          // Lista de archivos transcritos
          Expanded(
            child: ListView.separated(
              itemCount: fileList.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final filename = fileList[index];
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.file_present_rounded),
                      title: Text(filename),
                      // Botón de eliminación
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteConfirmationDialog(
                                onConfirm: () {
                                  deleteFile(filename); //Elimina un archivo de la carpeta
                                  _removeItem(index); // Actualiza la lista eliminándolo de la misma
                                },
                              );
                            },
                          );
                        },
                      ),
                      onTap: () {
                        // Navegar al visualizador de archivos cuando se presiona un elemento
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewText(filename: filename)),
                        );
                      },
                    ),
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