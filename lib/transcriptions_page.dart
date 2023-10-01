import 'package:flutter/material.dart';

import 'synthesis_page.dart';
import 'view_text_page.dart';
import 'file_manager_s.dart';
import 'delete_popup.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              _showCheckboxes ?
              SizedBox(
                width: MediaQuery.of(context).size.width-50,

                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      ),
                      Center(
                        child: Text(
                            'Selected ${fileObj.where((item) => item.checked).length} files',
                            style: const TextStyle(fontSize: 20)
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              List<ListItem> checkedItems = fileObj.where((item) => item.checked).toList();
                              if(checkedItems.isNotEmpty){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DeleteConfirmationDialog(
                                      onConfirm: () {
                                        deleteFiles(transcriptFolder,checkedItems.map((file) => file.text).toList()); //Elimina un archivo de la carpeta
                                        setState(() {
                                          fileObj.removeWhere((element) => element.checked); // Actualiza la lista eliminándolo de la misma
                                        });
                                      },
                                    );
                                  },
                                );
                              }
                            });
                          },
                          icon: const Icon(Icons.delete, size: 35)
                      ),
                    ]
                ),
              )
            : const Row(
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
                ],
              )
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
                    onTap: () {
                      // Navegar al visualizador de archivos cuando se presiona un elemento
                      if(!_showCheckboxes){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewText(filename: file.text, folder: folderPath)),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),

          _showCheckboxes ?
          ElevatedButton(
              onPressed: () {
                Iterable<ListItem> checkedItem =
                fileObj.where((item) => item.checked);
                if(checkedItem.isNotEmpty){
                  List<String> filenames = checkedItem.map((item) => item.text).toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SynthesisPage(folder: folderPath, pathList: filenames)),
                  );
                  setState(() {
                    _showCheckboxes = false;
                    for (var f in fileObj) {
                      f.checked = false;
                    }
                  });
                }
                },
              child: const Text('Process')
          ) : const ElevatedButton(
              onPressed: null,
              child: Text('Select Files to Process'))

        ],
      ),
    );
  }
}