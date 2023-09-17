import 'package:flutter/material.dart';

import 'synthesis_page.dart';
import 'view_text_page.dart';
import 'file_manager_s.dart';
import 'delete_popup.dart';
import 'dart:io';

class ListItem {
  String text;
  bool checked;

  ListItem(this.text, this.checked);
}

class TranscriptionsPage extends StatefulWidget {
  const TranscriptionsPage({super.key});

  @override
  State<TranscriptionsPage> createState() => _TranscriptionsPage();
}

class _TranscriptionsPage extends State<TranscriptionsPage> {
  List<ListItem> fileObj = [];

  String folderPath = "";
  String transcriptFolder = "transcriptions";

  bool _showCheckboxes = false;

  @override
  void initState() {
    super.initState();
    _getFiles();
  }

  void _getFiles() async {
    final folder = await createFolderInAppDocDir(transcriptFolder);
    final filenames = await getFilesInFolder(folder);

    setState(() {
      folderPath = folder;
      fileObj = filenames.map((text) => ListItem(text, false)).toList();
    });
  }

  void _removeItem(int index) {
    setState(() {
      fileObj.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _showCheckboxes ?
              IconButton(
                  onPressed: () {
                    setState(() {
                      _showCheckboxes = false;
                      for (var f in fileObj) {
                        f.checked = false;
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_back, size: 35)
              ) :
              const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.logout, size: 35)
              ),
              const SizedBox(width: 20),
              const Center(
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
              itemCount: fileObj.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final file = fileObj[index];

                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      _showCheckboxes = true;
                      setState(() {
                        file.checked = !file.checked;
                      });
                    });
                  },
                  child: ListTile(
                    leading: _showCheckboxes
                        ? Checkbox(
                        value: file.checked,
                        onChanged: (value) {
                          setState(() {
                            file.checked = !file.checked;
                          });
                        })
                        : const Icon(Icons.file_present_rounded),
                    title: Text(file.text),
                    // Botón de eliminación
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteConfirmationDialog(
                              onConfirm: () {
                                deleteFile(transcriptFolder,file.text); //Elimina un archivo de la carpeta
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
                        MaterialPageRoute(builder: (context) => ViewText(filename: file.text, folder: folderPath)),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          ElevatedButton(
              onPressed: () {
                ListItem firstCheckedItem =
                fileObj.firstWhere((item) => item.checked, orElse: () => ListItem('', false));
                if(firstCheckedItem.checked == true){
                  final text = firstCheckedItem.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SynthesisPage(path: '$folderPath/$text')),
                  );
                }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SynthesisPage(path: '$folderPath/badromance.txt')),
                  // );
                },
              child: const Text('Process')
          ),

        ],
      ),
    );
  }
}