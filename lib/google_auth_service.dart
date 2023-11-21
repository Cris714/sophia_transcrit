import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//hacer prueba crear cuenta google y luego por correo
//cambiar el user provider para google y hacer logout

class GoogleServiceApi {
  static final gAccount = GoogleSignIn(clientId: '889827346403-gh0d7fio87dickr412uapn4qaunu8f3u.apps.googleusercontent.com');

  // static Future<GoogleSignInAccount?> login() => gAccount.signIn();
  static signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await gAccount.signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future logout() => gAccount.disconnect();
}