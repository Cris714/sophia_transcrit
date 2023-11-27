import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/Managers/requests_manager.dart';
import 'package:sophia_transcrit2/UI_Pages/transcriptions_page.dart';
import 'package:sophia_transcrit2/UI_Pages/get_audio_page.dart';
import 'package:sophia_transcrit2/UI_Pages/documents_page.dart';
import 'package:sophia_transcrit2/Styles/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Managers/app_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AppProvider _appProvider;

  final List<Widget> screens = [
    const TranscriptionsPage(),
    const GetAudioPage(),
    const DocumentsPage(),
  ];

  // control de mensajes del backend
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'transcription') {
      _appProvider.setScreen(const TranscriptionsPage(), 0);
    }
    else if (message.data['type'] == 'document') {
      _appProvider.setScreen(const DocumentsPage(), 2);
    }
  }

  @override
  void initState() {
    setupInteractedMessage();
    () async {
      await Permission.notification.request();
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    } ();
    super.initState();
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      if (message.data['type'] == 'transcript') {
        await getTranscription();
        _appProvider.getTranscriptions();
      } else if (message.data['type'] == 'documents') {
        // _appProvider.getDocuments();
      }
    });
  }

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    Widget currentScreen = appProvider.currentScreen;
    int currentTab = appProvider.currentTab;

    return Scaffold(
      appBar: AppBar(title: const Text('Sophia Transcrit')),
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
