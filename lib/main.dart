import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/colors.dart';
import 'package:sophia_transcrit2/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(), // Debes crear una instancia de tu AppProvider
      child: const SophiaTranscritMain(),
    ),
  );
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