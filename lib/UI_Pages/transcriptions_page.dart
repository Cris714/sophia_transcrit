import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sophia_transcrit2/Styles/colors.dart';
import 'package:sophia_transcrit2/Authentication/login.dart';
import 'package:sophia_transcrit2/Managers/requests_manager.dart';

import '../Managers/app_provider.dart';
import 'synthesis_page.dart';
import 'view_text_page.dart';
import '../Managers/file_manager_s.dart';
import 'delete_popup.dart';

class TranscriptionsPage extends StatefulWidget {
  const TranscriptionsPage({super.key});

  @override
  State<TranscriptionsPage> createState() => _TranscriptionsPage();
}

class _TranscriptionsPage extends State<TranscriptionsPage> with WidgetsBindingObserver {
  bool _showOptions = false;
  late AppProvider _appProvider;
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _appProvider = Provider.of<AppProvider>(context, listen: false);

      if(_appProvider.showCardTrans) {
        showMessage('Your transcription has been sent correctly');
        _appProvider.setShowCardTrans(false);
      }

      () async {
        await getTranscription();
        await _appProvider.getTranscriptions();
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
        await getTranscription();
        _appProvider.getTranscriptions();
      } ();
    }
  }

  Future<void> updateFiles() async{
    await getTranscription();
    _appProvider.getTranscriptions();
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

  @override

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text),
          backgroundColor: yellow,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 60),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        )
    );
  }

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
                                        deleteFiles("${FirebaseAuth.instance.currentUser!.uid}/transcriptions",checkedItems.map((file) => file.text).toList());
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
            : const Row(
                children: [
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
            child: RefreshIndicator(
              onRefresh: updateFiles,
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

    if(_appProvider.showErrors) AlertDialog(
        title: const Text('Oops! Something went wrong...'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          child: Scrollbar(
            controller: _vertical,
            thumbVisibility: true,
            trackVisibility: true,
            child: Scrollbar(
              controller: _horizontal,
              thumbVisibility: true,
              trackVisibility: true,
              notificationPredicate: (notif) => notif.depth == 1,
              child: SingleChildScrollView(
                controller: _vertical,
                child: SingleChildScrollView(
                  controller: _horizontal,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('File')),
                      DataColumn(label: Text('StatusCode')),
                    ],
                    rows: [
                      for (var error in _appProvider.errors)
                        DataRow(
                          cells: [
                            DataCell(Text(error.text)),
                            DataCell(
                                statusError[error.statusCode] == null ?
                                Text('Code error ${error.statusCode}')
                                    : Text('${error.statusCode}: ${statusError[error.statusCode]}')
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
        actions: [
          TextButton(
            onPressed: () {
            _appProvider.setShowErrors(false);
            _appProvider.clearErrors();
            },
            child: const Text('Close'),
          )
        ]
      ),

          _showOptions ?
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
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
          ) : ElevatedButton(
              onPressed: () {
                showMessage('Check file to process');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Process files')),
        ],
      ),
    );
  }
}