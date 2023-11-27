import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sophia_transcrit2/Managers/requests_manager.dart';

//hacer prueba crear cuenta google y luego por correo

class GoogleServiceApi {

  static signInWithGoogle() async {

    final GoogleSignInAccount? gUser = await GoogleSignIn(
      clientId: '889827346403-gh0d7fio87dickr412uapn4qaunu8f3u.apps.googleusercontent.com',
    ).signIn();

    String _googleUserEmail = gUser!.email;

    debugPrint(_googleUserEmail);

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    UserCredential uCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    User? user = uCredential.user;

    if(uCredential.additionalUserInfo!.isNewUser) {
      await registerUser();
    }

    return user;
  }

  static Future logout() async {
    await GoogleSignIn(
    clientId: '889827346403-gh0d7fio87dickr412uapn4qaunu8f3u.apps.googleusercontent.com',
    ).disconnect();
  }
}