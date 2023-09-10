import 'package:flutter/material.dart';

import 'transcriptions_page.dart';
import 'documents_page.dart';
import 'get_audio_page.dart';

void main() {
  runApp(const SophiaTranscritMain());
}

class SophiaTranscritMain extends StatelessWidget {
  const SophiaTranscritMain({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      home: const DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              TranscriptionsPage(),
              GetAudioPage(),
              DocumentsPage(),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.storage),
                text: 'Transcriptions',
              ),
              Tab(
                icon: Icon(Icons.add),
                text: 'Get Audio',
              ),
              Tab(
                icon: Icon(Icons.article),
                text: 'Documents',
              ),
            ],
          ),
        ),
      ),
    );
  }
}