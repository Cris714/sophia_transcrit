import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/transcriptions_page.dart';
import 'package:sophia_transcrit2/get_audio_page.dart';
import 'package:sophia_transcrit2/documents_page.dart';
import 'package:sophia_transcrit2/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import 'file_manager_s.dart';

Map<int, String> statusError = {
  0: 'Connexion Timeout. Connect to internet',
  504: 'Server not responding. Try again later.',
  404: 'File not found'
};

class ListItem {
  String text;
  bool checked;

  ListItem(this.text, this.checked);
}

class errorItem {
  String text;
  int statusCode;

  errorItem(this.text, this.statusCode);
}

class AppProvider extends ChangeNotifier { // create a common file for data
  Widget _currentScreen = GetAudioPage();
  int _currentTab = 1;
  List<ListItem> _fileTrans = [];
  String _folderTrans = "";
  bool _showCardTrans = false;
  bool _showErrors = false;
  List<ListItem> _fileDocs = [];
  String _folderDocs = "";
  bool _showCardDocs = false;
  List<errorItem> _errors = [];
  bool _showDocsErrors = false;
  List<errorItem> _docsErrors = [];
  bool _showCardAudio = false;

  Widget get currentScreen => _currentScreen;
  int get currentTab => _currentTab;
  List<ListItem> get fileTrans => _fileTrans;
  String get folderTrans => _folderTrans;
  List<ListItem> get fileDocs => _fileDocs;
  String get folderDocs => _folderDocs;
  bool get showCardTrans => _showCardTrans;
  bool get showErrors => _showErrors;
  bool get showCardDocs => _showCardDocs;
  bool get showDocsErrors => _showDocsErrors;
  List<errorItem> get errors => _errors;
  List<errorItem> get docsErrors => _docsErrors;
  bool get showCardAudio => _showCardAudio;

  void clearErrors(){
    _errors.clear();
    notifyListeners();
  }

  void clearDocsErrors(){
    _docsErrors.clear();
    notifyListeners();
  }

  void addDocsError(errorItem newError){
    _docsErrors.add(newError);
    notifyListeners();
  }

  void addError(errorItem newError){
    _errors.add(newError);
    notifyListeners();
  }

  void setShowDocsErrors(newBool) {
    _showDocsErrors = newBool;
    notifyListeners();
  }

  void setShowErrors(newBool) {
    _showErrors = newBool;
    notifyListeners();
  }

  void setShowCardTrans(newBool) {
    _showCardTrans = newBool;
    notifyListeners();
  }

  void setShowCardDocs(newBool) {
    _showCardDocs = newBool;
    notifyListeners();
  }

  void setShowCardAudio(newBool) {
    _showCardAudio = newBool;
    notifyListeners();
  }

  void setScreen(Widget newScreen, int newTab) {
    _currentScreen = newScreen;
    _currentTab = newTab;

    if(newTab != 0) {
      for (var f in _fileTrans) {
        f.checked = false;
      }
    } else if(newTab != 2) {
      for (var f in _fileDocs) {
        f.checked = false;
      }
    }

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

  @override
  void initState() {
    () async {
      await Permission.notification.request();
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    } ();
    super.initState();
  }

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
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
        color: sophiaprimary,
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
                            color: currentTab == 0 ? Colors.white : sophiasecondarygreen[200],
                          ),
                          Text(
                            'Transcriptions',
                            style: TextStyle(
                              color: currentTab == 0 ? Colors.white : sophiasecondarygreen[200],
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
                            color: currentTab == 1 ? Colors.white : sophiasecondarygreen[200],
                          ),
                          Text(
                            'Get audio',
                            style: TextStyle(
                              color: currentTab == 1 ? Colors.white : sophiasecondarygreen[200],
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
                            color: currentTab == 2 ? Colors.white : sophiasecondarygreen[200],
                          ),
                          Text(
                            'Documents',
                            style: TextStyle(
                              color: currentTab == 2 ? Colors.white : sophiasecondarygreen[200],
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
