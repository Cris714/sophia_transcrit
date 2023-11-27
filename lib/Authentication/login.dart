import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sophia_transcrit2/Managers/requests_manager.dart';

import 'google_auth_service.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailResetController = TextEditingController();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text),
          backgroundColor: Colors.green,
        )
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text),
          backgroundColor: Colors.red,
        )
    );
  }

  void signInWithGoogle() async {
    await GoogleServiceApi.signInWithGoogle();
    await updateTokenNotification();
  }

  void resetPassword() async {
    try {
      String? email = await resetPasswordDialog();
      if(email != null && email.isNotEmpty) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showMessage('Email sent successfully');
      } else {
        if(email != null && email.isEmpty) showError('Empty email');
      }
    } on FirebaseAuthException catch(e) {
      showError(e.code);
    }
  }

  void signUserIn() async {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   }
    // );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await updateTokenNotification();
    } on FirebaseAuthException catch(e) {
      if(e.code == 'user-not-found') {
        showError('No user found for that email');
      } else {
        showError('Incorrect username or password');
      }
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xFF4C29C9),
              ),
              hintText: 'Enter your Email',
            ),
            controller: emailController,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            obscureText: true,
            style: const TextStyle(
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xFF4C29C9),
              ),
              hintText: 'Enter your Password',
            ),
            controller: passwordController,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: resetPassword,
        child: const Text(
          'Forgot Password?',
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return SizedBox(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black26),
            child: Checkbox(
              value: _rememberMe,
              // checkColor: Colors.green,
              // activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
          ),
          const Text(
            'Remember me',
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: signUserIn,
        child: const Text(
          'Sign In',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 30.0),
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            width: 200,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const FaIcon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
              onPressed: signInWithGoogle,
              label: const Text('Sign In with Google'),
            ),
          )
        ],
      );
    // );
  }

  Future<String?> resetPasswordDialog() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
        title: const Text('Reset your password'),
        content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
                hintText: 'Enter your email address'
            ),
            controller: emailResetController
        ),
        actions: [
          TextButton(
            onPressed: () {Navigator.of(context).pop();},
            child: const Text('Go back'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(emailResetController.text);
              emailResetController.clear();
            },
            child: const Text('Send email'),
          )
        ]
    ),
  );

  Widget _buildSignupBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
            'Don\'t have an Account? ',
            style: TextStyle(
              color: Colors.black,
            ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: widget.onTap,
          child: const Text(
              'Register Now',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    // vertical: 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 120.0),
                      const Image(
                          image: AssetImage('assets/logo.png'),
                        height: 100,
                      ),
                      const Text(
                        'Welcome to Sophia Transcrit',
                        style: TextStyle(
                            fontSize: 18.0
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      _buildEmailTF(),
                      _buildPasswordTF(),
                      _buildForgotPasswordBtn(),
                      _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
                      _buildSignupBtn(),
                      _buildSocialBtnRow(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}