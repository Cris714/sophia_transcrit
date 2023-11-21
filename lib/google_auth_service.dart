import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleServiceApi {
  static signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn(clientId: "889827346403-gh0d7fio87dickr412uapn4qaunu8f3u.apps.googleusercontent.com").signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}