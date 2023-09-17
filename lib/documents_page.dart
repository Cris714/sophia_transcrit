import 'package:flutter/material.dart';

import 'view_text_page.dart';
import 'file_manager_s.dart';
import 'delete_popup.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPage();
}

class _DocumentsPage extends State<DocumentsPage> {
  Future<void> computeFuture = Future.value();
  List<String> fileList = [];
  String folderPath = "";

  String documentFolder = "documents";

  @override
  void initState() {
    super.initState();
    _getFiles();
  }

  void _getFiles() async {
    final folder = await createFolderInAppDocDir(documentFolder);
    final filenames = await getFilesInFolder(folder);

    setState(() {
      fileList = filenames;
      folderPath = folder;
    });
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
                      "My Documents",
                      style: TextStyle(fontSize: 20)
                  ),
                ),
              ]
          ),
          const Divider(),

          // Lista de archivos procesados
          Expanded(
            child: ListView.separated(
              itemCount: fileList.length,
              separatorBuilder: (context, index) => const Divider(),
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
                                  deleteFile('documents',filename); //Elimina un archivo de la carpeta
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
                          MaterialPageRoute(builder: (context) => ViewText(filename: filename, folder: folderPath)),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
