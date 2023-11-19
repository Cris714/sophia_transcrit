import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';
import 'firebase_options.dart';

import 'package:sophia_transcrit2/colors.dart';

import 'app_provider.dart';
import 'home.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        primarySwatch: sophiaprimary,
        fontFamily: 'MuktaVaani',
      ),

      darkTheme: ThemeData.light(),
      // home: LoginScreen(),
      // home: Home(),
      home: AuthPage(),

    );
  }
}