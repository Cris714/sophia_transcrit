import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'get_audio_page.dart';
import 'home.dart';
import 'view_text_page.dart';
import 'file_manager_s.dart';
import 'delete_popup.dart';

class ListItem {
  String text;
  bool checked;

  ListItem(this.text, this.checked);
}

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPage();
}

class _DocumentsPage extends State<DocumentsPage> {
  Future<void> computeFuture = Future.value();
  List<ListItem> fileObj = [];
  String folderPath = "";

  String documentFolder = "documents";
  bool _showOptions = false;

  late AppProvider _appProvider;

  @override
  void initState() {
    super.initState();
    _getFiles();
    _appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  void updateScreen() {
    _appProvider.setScreen(GetAudioPage(),1);
  }

  Future<void> _getFiles() async {
    final folder = await createFolderInAppDocDir(documentFolder);
    final filenames = await getFilesInFolder(folder);

    setState(() {
      fileObj = filenames.map((text) => ListItem(text, false)).toList();
      folderPath = folder;
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
                _showOptions ?
                SizedBox(
                  width: MediaQuery.of(context).size.width-50,

                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _showOptions = false;
                                for (var f in fileObj) {
                                  f.checked = false;
                                }
                              });
                            },
                            icon: const Icon(Icons.arrow_back, size: 35)
                        ),
                        Center(
                          child: fileObj.where((item) => item.checked).toList().isNotEmpty ? Text(
                              'Selected ${fileObj.where((item) => item.checked).length} files',
                              style: const TextStyle(fontSize: 20)
                          ) : const Text('Select files', style: TextStyle(fontSize: 20)),
                        ),
                        IconButton(
                            onPressed: () async {
                              List<ListItem> checkedItems = fileObj.where((item) => item.checked).toList();
                              if(checkedItems.isNotEmpty){
                                Share.shareXFiles(checkedItems.map((file) => XFile('$folderPath/${file.text}')).toList(),
                                    text: "Check out this transcription I've made!");
                              }
                            },
                            icon: const Icon(Icons.share, size: 35)
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
                                          deleteFiles(documentFolder,checkedItems.map((file) => file.text).toList()); //Elimina un archivo de la carpeta
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
                    : Row(
                  children: [
                    IconButton(
                        onPressed: updateScreen,
                        icon: Icon(Icons.logout, size: 35)
                    ),
                    SizedBox(width: 20),
                    Center(
                      child: Text(
                          "My Documents",
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
            child: RefreshIndicator(
              onRefresh: _getFiles,
              child: ListView.separated(
                itemCount: fileObj.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final file = fileObj[index];

                  return ListTile(
                    leading: Checkbox(
                        value: file.checked,
                        onChanged: (value) {
                          setState(() {
                            file.checked = !file.checked;
                            if (fileObj.where((item) => item.checked).isNotEmpty){
                              setState(() {
                                _showOptions = true;
                              });
                            }
                          });
                        }),
                    title: Text(file.text),
                    onTap: () {
                      // Navegar al visualizador de archivos cuando se presiona un elemento
                      if(!_showOptions){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewText(filename: file.text, folder: folderPath)),
                        );
                      }
                    },
                  );
                },
              ),
            )
          ),
        ],
      ),
    );
  }
}