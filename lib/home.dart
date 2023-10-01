import 'package:flutter/material.dart';
import 'package:sophia_transcrit2/transcriptions_page.dart';
import 'package:sophia_transcrit2/get_audio_page.dart';
import 'package:sophia_transcrit2/documents_page.dart';
import 'package:sophia_transcrit2/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int currentTab = 1;
  final List<Widget> screens = [
    TranscriptionsPage(),
    GetAudioPage(),
    DocumentsPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = GetAudioPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sophia Transcrit')),
      body: PageStorage(
          bucket: bucket,
          child: currentScreen,
      ),
/*      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: const Text('Import Audio'),
        icon: Icon(Icons.drive_folder_upload),

      ),*/
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
