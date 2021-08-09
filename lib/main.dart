import 'package:flutter/material.dart';
import 'package:letschat/helper/authenticate.dart';
import 'package:letschat/helper/helperFunction.dart';
import 'package:letschat/views/chatRoomScreen.dart';
import 'views/signInScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/signUpScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((val) {
      setState(() {
        userIsLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: true,
        home: userIsLoggedIn ? ChatRoomScreen() : Authenticate());
  }
}
