import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Authentication/auth_page.dart';

import 'package:sophia_transcrit2/Styles/colors.dart';

import '../Managers/app_provider.dart';
import '../Authentication/firebase_options.dart';
import '../Notification/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  /*AwesomeNotifications().initialize(
      'resource://drawable/notification_icon',
      [            // notification icon
        NotificationChannel(
          channelGroupKey: 'basic_test',
          channelKey: 'basic',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          channelShowBadge: true,
          importance: NotificationImportance.High,
          enableVibration: true,
        ),

      ]
  );*/

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
      home: AuthPage(),

    );
  }
}

//Autologueo cuando entrar a la app
//Verificación de correo y contraseña