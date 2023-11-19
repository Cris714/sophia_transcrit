import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'app_provider.dart';
import 'google_auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late AppProvider appProvider;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text),
          backgroundColor: Colors.red,)
    );
  }

  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    try {
      if(passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        appProvider.setUser(FirebaseAuth.instance.currentUser);
      } else {
        showMessage('Passwords don\'t match!');
      }
    } on FirebaseAuthException catch(e) {
      if(e.code == 'user-not-found') {
        showMessage('No user found for that email');
      } else {
        showMessage('Incorrect username or password');
      }
    }

    Navigator.pop(context);
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
        Text('Password'),
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

  Widget _buildConfirmPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Confirm Password'),
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
              hintText: 'Confirm your Password',
            ),
            controller: confirmPasswordController,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: signUserUp,
        child: const Text(
          'Sign Up',
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
            onPressed: GoogleServiceApi.signInWithGoogle,
            label: const Text('Sign Up with Google'),
          ),
        )
      ],
    );
    // );
  }

  Widget _buildSigninBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an Account? ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: widget.onTap,
          child: const Text(
            'Login Now',
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
    appProvider = Provider.of<AppProvider>(context, listen: true);

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
                          'Let\'s create an account!',
                        style: TextStyle(
                          fontSize: 18.0
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      _buildEmailTF(),
                      _buildPasswordTF(),
                      _buildConfirmPasswordTF(),
                      _buildLoginBtn(),
                      _buildSigninBtn(),
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