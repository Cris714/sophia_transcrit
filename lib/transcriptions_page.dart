import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'home.dart';
import 'synthesis_page.dart';
import 'view_text_page.dart';
import 'file_manager_s.dart';
import 'delete_popup.dart';
import 'get_audio_page.dart';

class TranscriptionsPage extends StatefulWidget {
  const TranscriptionsPage({super.key});

  @override
  State<TranscriptionsPage> createState() => _TranscriptionsPage();
}

class _TranscriptionsPage extends State<TranscriptionsPage> {
  bool _showOptions = false;
  late AppProvider _appProvider;

  @override
  void initState() {
    super.initState();
  }

  void updateScreen() {
    _appProvider.setScreen(GetAudioPage(),1);
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context, listen: true);
    if(_appProvider.showCardTrans){
      Timer(const Duration(seconds: 1), () {
        _appProvider.setShowCardTrans(false);
      });
    }
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
                              for (var f in _appProvider.fileTrans) {
                                f.checked = false;
                              }
                            });
                          },
                          icon: const Icon(Icons.arrow_back, size: 35)
                      ),
                      Center(
                        child: Text(
                            'Selected ${_appProvider.fileTrans.where((item) => item.checked).length} files',
                            style: const TextStyle(fontSize: 20)
                        )
                      ),
                      IconButton(
                          onPressed: () async {
                            List<ListItem> checkedItems = _appProvider.fileTrans.where((item) => item.checked).toList();
                            if(checkedItems.isNotEmpty){
                              Share.shareXFiles(checkedItems.map((file) => XFile('${_appProvider.folderTrans}/${file.text}')).toList(),
                                      text: "Check out this transcription I've made!");
                            }
                          },
                          icon: const Icon(Icons.share, size: 35)
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              List<ListItem> checkedItems = _appProvider.fileTrans.where((item) => item.checked).toList();
                              if(checkedItems.isNotEmpty){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DeleteConfirmationDialog(
                                      onConfirm: () {
                                        deleteFiles("transcriptions",checkedItems.map((file) => file.text).toList());
                                        setState(() {
                                          _appProvider.fileTrans.removeWhere((element) => element.checked); // Actualiza la lista eliminándolo de la misma
                                          _showOptions = false;
                                        });//Elimina un archivo de la carpeta
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
                      icon: const Icon(Icons.logout, size: 35)
                  ),
                  const SizedBox(width: 20),
                  const Center(
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
            child: RefreshIndicator(
              onRefresh: _appProvider.getTranscriptions,
              child: ListView.separated(
                itemCount: _appProvider.fileTrans.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final file = _appProvider.fileTrans[index];

                  return ListTile(
                    leading: Checkbox(
                        value: file.checked,
                        onChanged: (value) {
                          setState(() {
                            file.checked = !file.checked;
                            if (_appProvider.fileTrans.where((item) => item.checked).isNotEmpty){
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
                        // : const Icon(Icons.file_present_rounded),
                    title: Text(file.text),
                    onTap: () {
                      // Navegar al visualizador de archivos cuando se presiona un elemento
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewText(filename: file.text, folder: _appProvider.folderTrans)),
                      );
                    },
                  );
                },
              ),
            ),
          ),


          _appProvider.showErrors ? AlertDialog(
            title: const Text('Oops! Something went wrong...'),
            content: SingleChildScrollView(
                child:SizedBox(
                  height: 200,
                    child: ListView.separated(
                    itemCount: _appProvider.errors.length+1,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return index == 0 ? const ListTile(
                        title: Text("File"),
                        trailing: Text("Status Code"),
                      ) :
                      ListTile(
                        title: Text(_appProvider.errors[index-1].text),
                        trailing: Text("${_appProvider.errors[index-1].statusCode}"),
                      );
                    }
                    )
                )
            ),
              contentPadding: EdgeInsets.all(10),
              actions: [
                TextButton(
                  onPressed: () {
                  _appProvider.setShowErrors(false);
                  _appProvider.clearErrors();
                  },
                  child: const Text('Close'),
                )
              ]
          ) : const Text(""),

        AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _appProvider.showCardTrans ? 1.0 : 0.0, // Controla la opacidad
          child: const Card(
            elevation: 4,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Transcription has been performed correctly',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),

          _showOptions ?
          ElevatedButton(
              onPressed: () {
                Iterable<ListItem> checkedItem =
                _appProvider.fileTrans.where((item) => item.checked);
                if(checkedItem.isNotEmpty){
                  List<String> filenames = checkedItem.map((item) => item.text).toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SynthesisPage(folder: _appProvider.folderTrans, pathList: filenames)),
                  );
                  setState(() {
                    _showOptions = false;
                    for (var f in _appProvider.fileTrans) {
                      f.checked = false;
                    }
                  });
                }
                },
              child: const Text('Process files')
          ) : const ElevatedButton(
              onPressed: null,
              child: Text('Check Files to Process'))
        ],
      ),
    );
  }
}