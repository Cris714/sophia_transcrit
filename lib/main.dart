import 'package:flutter/material.dart';
import 'package:sophia_transcrit2/colors.dart';
import 'package:sophia_transcrit2/home.dart';

void main() {
  runApp(const SophiaTranscritMain());
}


class SophiaTranscritMain extends StatelessWidget {
  const SophiaTranscritMain({super.key});




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sophia Transcrit',
      theme: ThemeData(
        primarySwatch: primary,
        fontFamily: 'Merriweather',
      ),


      darkTheme: ThemeData.light(),
      home: Home(),




    );
  }
}