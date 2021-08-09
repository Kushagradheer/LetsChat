import 'package:flutter/material.dart';
import 'package:letschat/views/signInScreen.dart';
import 'package:letschat/views/signUpScreen.dart';

//Helper Class Authenticate is created for better interface of signIn and signOut
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInScreen(toggleView);
    } else {
      return SignUpScreen(toggleView);
    }
  }
}
