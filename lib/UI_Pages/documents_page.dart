import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sophia_transcrit2/Managers/requests_manager.dart';

import '../Managers/app_provider.dart';
import 'view_text_page.dart';
import '../Managers/file_manager_s.dart';
import 'delete_popup.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPage();
}

class _DocumentsPage extends State<DocumentsPage> with WidgetsBindingObserver {
  Future<void> computeFuture = Future.value();
  bool _showOptions = false;
  late AppProvider _appProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _appProvider = Provider.of<AppProvider>(context, listen: false);

      if(_appProvider.showCardDocs) {
        showMessage('Your document has been sent correctly');
        _appProvider.setShowCardDocs(false);
      }
      () async {
        await getDocument();
        _appProvider.getDocuments();
      } ();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      () async {
        await getDocument();
        _appProvider.getDocuments();
      } ();
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 60),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        )
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> updateFiles() async{
    await getTranscription();
    _appProvider.getTranscriptions();
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context, listen: true);
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
                                for (var f in _appProvider.fileDocs) {
                                  f.checked = false;
                                }
                              });
                            },
                            icon: const Icon(Icons.arrow_back, size: 35)
                        ),
                        Center(
                          child: Text(
                              'Selected ${_appProvider.fileDocs.where((item) => item.checked).length} files',
                              style: const TextStyle(fontSize: 20)
                          )
                        ),
                        IconButton(
                            onPressed: () async {
                              List<ListItem> checkedItems = _appProvider.fileDocs.where((item) => item.checked).toList();
                              if(checkedItems.isNotEmpty){
                                Share.shareXFiles(checkedItems.map((file) => XFile('${_appProvider.folderDocs}/${file.text}')).toList(),
                                    text: "Check out this transcription I've made!");
                              }
                            },
                            icon: const Icon(Icons.share, size: 35)
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                List<ListItem> checkedItems = _appProvider.fileDocs.where((item) => item.checked).toList();
                                if(checkedItems.isNotEmpty){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DeleteConfirmationDialog(
                                        onConfirm: () {
                                          deleteFiles("${FirebaseAuth.instance.currentUser!.uid}/documents",checkedItems.map((file) => file.text).toList()); //Elimina un archivo de la carpeta
                                          setState(() {
                                            _appProvider.fileDocs.removeWhere((element) => element.checked); // Actualiza la lista eliminándolo de la misma
                                            _showOptions = false;
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
              onRefresh: updateFiles,
              child: ListView.separated(
                itemCount: _appProvider.fileDocs.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final file = _appProvider.fileDocs[index];

                  return ListTile(
                    leading: Checkbox(
                        value: file.checked,
                        onChanged: (value) {
                          setState(() {
                            file.checked = !file.checked;
                            if (_appProvider.fileDocs.where((item) => item.checked).isNotEmpty){
                              setState(() {
                                _showOptions = true;
                              });
                            } else {
                              setState(() {
                                _showOptions = false;
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
                          MaterialPageRoute(builder: (context) => ViewText(filename: file.text, folder: _appProvider.folderDocs)),
                        );
                      }
                    },
                  );
                },
              ),
            )
          ),

          if(_appProvider.showDocsErrors) AlertDialog(
              title: const Text('Errors found'),
              content: SingleChildScrollView(
                  child:SizedBox(
                      height: 200,
                      child: ListView.separated(
                          itemCount: _appProvider.docsErrors.length+1,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            return index == 0 ? const ListTile(
                                title: Text("File"),
                                trailing: Text("Status Code"),
                              ) :
                            ListTile(
                                title: Text(_appProvider.docsErrors[index-1].text),
                                trailing: Text("${_appProvider.docsErrors[index-1].statusCode}")
                            );
                          }
                      )
                  )
              ),
              contentPadding: const EdgeInsets.all(10),
              actions: [
                TextButton(
                  onPressed: () {
                    _appProvider.setShowDocsErrors(false);
                    _appProvider.clearDocsErrors();
                  },
                  child: const Text('Close'),
                )
              ]
          )

        ],
      ),
    );
  }
}