import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/transcriptions_page.dart';
import 'package:sophia_transcrit2/get_audio_page.dart';
import 'package:sophia_transcrit2/documents_page.dart';
import 'package:sophia_transcrit2/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import 'file_manager_s.dart';

class ListItem {
  String text;
  bool checked;

  ListItem(this.text, this.checked);
}

class AppProvider extends ChangeNotifier { // create a common file for data
  Widget _currentScreen = GetAudioPage();
  int _currentTab = 1;
  List<ListItem> _fileTrans = [];
  String _folderTrans = "";
  List<ListItem> _fileDocs = [];
  String _folderDocs = "";

  Widget get currentScreen => _currentScreen;
  int get currentTab => _currentTab;
  List<ListItem> get fileTrans => _fileTrans;
  String get folderTrans => _folderTrans;
  List<ListItem> get fileDocs => _fileDocs;
  String get folderDocs => _folderDocs;

  void setScreen(Widget newScreen, int newTab) {
    _currentScreen = newScreen;
    _currentTab = newTab;
    notifyListeners();
  }

  void setTranscriptions(newFileObj) {
    _fileTrans = newFileObj;
    notifyListeners();
  }

  void setDocuments(newFileObj) {
    _fileDocs = newFileObj;
    notifyListeners();
  }

  void addTranscription(String text) {
    _fileTrans.insert(0, ListItem(text, false));
    notifyListeners(); // Notifica a los oyentes que la lista ha cambiado
  }

  void addDocument(String text) {
    _fileDocs.insert(0, ListItem(text, false));
    notifyListeners(); // Notifica a los oyentes que la lista ha cambiado
  }

  Future<void> getTranscriptions() async {
    _folderTrans = await createFolderInAppDocDir("transcriptions");
    final filenames = await getFilesInFolder(_folderTrans);
    final files = filenames.map((text) => ListItem(text, false)).toList();
    setTranscriptions(files);
    notifyListeners();
  }

  Future<void> getDocuments() async {
    _folderDocs = await createFolderInAppDocDir("documents");
    final filenames = await getFilesInFolder(_folderDocs);
    final files = filenames.map((text) => ListItem(text, false)).toList();
    setDocuments(files);
    notifyListeners();
  }

  AppProvider() {
    getTranscriptions();
    getDocuments();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final List<Widget> screens = [
    TranscriptionsPage(),
    GetAudioPage(),
    DocumentsPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    () async {
      Permission.notification.request();
      Permission.storage.request();
      Permission.microphone.request();
    } ();

    final appProvider = Provider.of<AppProvider>(context);
    Widget currentScreen = appProvider.currentScreen;
    int currentTab = appProvider.currentTab;

    return Scaffold(
      appBar: AppBar(title: Text('Sophia Transcrit')),
      body: PageStorage(
          bucket: bucket,
          child: currentScreen,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        color: primary,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                      setState(() {
                        currentScreen = TranscriptionsPage();
                        currentTab = 0;
                        appProvider.setScreen(TranscriptionsPage(), 0);
                      });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.storage,
                            color: currentTab == 0 ? Colors.white: primary[300],
                          ),
                          Text(
                            'Transcriptions',
                            style: TextStyle(
                              color: currentTab == 0 ? Colors.white: primary[300],
                            ),
                          )
                        ],
                      )
                  ),
                  MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = GetAudioPage();
                          currentTab = 1;
                          appProvider.setScreen(GetAudioPage(), 1);
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: currentTab == 1 ? Colors.white: primary[300],
                          ),
                          Text(
                            'Get audio',
                            style: TextStyle(
                              color: currentTab == 1 ? Colors.white: primary[300],
                            ),
                          )
                        ],
                      )
                  ),
                  MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = DocumentsPage();
                          currentTab = 2;
                          appProvider.setScreen(DocumentsPage(), 2);
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article,
                            color: currentTab == 2 ? Colors.white: primary[300],
                          ),
                          Text(
                            'Documents',
                            style: TextStyle(
                              color: currentTab == 2 ? Colors.white: primary[300],
                            ),
                          )
                        ],
                      )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
