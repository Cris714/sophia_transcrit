import 'package:flutter/material.dart';
import 'package:sophia_transcrit2/colors.dart';

import 'transcriptions_page.dart';
import 'documents_page.dart';
import 'get_audio_page.dart';

import 'dart:async';
import 'dart:convert';
import 'package:xml/xml.dart' as http;

void main() {
  runApp(const SophiaTranscritMain());
}


class SophiaTranscritMain extends StatelessWidget {
  const SophiaTranscritMain({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sophia Transcrit",
      theme: ThemeData(
        primarySwatch: primary,
        fontFamily: 'Merriweather',
      ),

      darkTheme: ThemeData.light(),
      home: DefaultTabController(initialIndex: 1, length: 3, child: Scaffold(

        appBar: AppBar(
          backgroundColor: primary[300],
          elevation: 20,
          bottom: TabBar(
              labelStyle: TextStyle(fontSize: 15),
            unselectedLabelColor: primary[100], //letras no seleccionadas
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: primary
            ),

            tabs: [
              Tab(
                icon: Icon(Icons.storage, color: Colors.white),
                text: 'Transcriptions',
              ),
              Tab(
                icon: Icon(Icons.add, color: Colors.white),
                text: 'Get Audio',
              ),
              Tab(
                icon: Icon(Icons.article, color: Colors.white),
                text: 'Documents',
              ),
            ]),
        ),
          body: const TabBarView(children: [
              TranscriptionsPage(),
              GetAudioPage(),
              DocumentsPage(),
            ]),
        ),
      ),
    );
  }
}