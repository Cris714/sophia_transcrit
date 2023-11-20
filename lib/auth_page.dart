

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sophia_transcrit2/login_or_register_page.dart';
import 'home.dart';

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
            return Home();
          }
          //user not log in
          else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}