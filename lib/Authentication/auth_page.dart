import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sophia_transcrit2/Authentication/login_or_register_page.dart';
import 'package:sophia_transcrit2/Authentication/verify_email.dart';

import '../UI_Pages/home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user log in
          if(snapshot.hasData) {
            if(snapshot.data!.providerData[0].providerId == 'google.com') {
              return const Home();
            } else {
              return const VerifyEmail();
            }
          }
          // user not log in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}