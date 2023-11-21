import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/transcriptions_page.dart';
import 'package:sophia_transcrit2/get_audio_page.dart';
import 'package:sophia_transcrit2/documents_page.dart';
import 'package:sophia_transcrit2/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_provider.dart';

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
              IntrinsicWidth(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: MaterialButton(
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
                              'Record',
                              style: TextStyle(
                                color: currentTab == 1 ? Colors.white : sophiasecondarygreen[200],
                              ),
                            )
                          ],
                        )
                    )),
                    Expanded(child: MaterialButton(
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
                              'Transcripts',
                              style: TextStyle(
                                color: currentTab == 0 ? Colors.white : sophiasecondarygreen[200],
                              ),
                            )
                          ],
                        )
                    )),
                    Expanded(child: MaterialButton(
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
                    )),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
