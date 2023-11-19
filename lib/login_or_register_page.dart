
import 'package:flutter/cupertino.dart';
import 'package:sophia_transcrit2/login.dart';
import 'package:sophia_transcrit2/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPage();
}

class _LoginOrRegisterPage extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if( showLoginPage ) {
      return LoginScreen(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}