import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letschat/Widgets/widgets.dart';
import 'package:letschat/helper/helperFunction.dart';
import 'package:letschat/services/auth.dart';
import 'package:letschat/services/database.dart';

import 'chatRoomScreen.dart';

class SignInScreen extends StatefulWidget {
  final Function toggle;
  SignInScreen(this.toggle);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  bool isloading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshotUserInfo;

  TextEditingController emailIDTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signIn() async {
    if (formKey.currentState.validate()) {
      // HelperFunctions.saveUserEmailSharedPreference(
      //     emailIDTextEditingController.text);
      databaseMethods
          .getUserByEmail(emailIDTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserEmailSharedPreference(
            snapshotUserInfo.docs[0].get("name"));
      });
      setState(() {
        isloading = true;
      });

      await authMethods
          .signInWithYourEmailAndPassword(emailIDTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) async {
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
//          HelperFunctions.saveUserNameSharedPreference(
          //            snapshotUserInfo.docs[0].get("userName"));
          //      HelperFunctions.saveUserEmailSharedPreference(
          //        snapshotUserInfo.docs[0].get("email"));

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChatRoomScreen()));
        } else {
          setState(() {
            isloading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarMain(context),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Enter correct email";
                        },
                        controller: emailIDTextEditingController,
                        decoration: textFieldInputDecoration("E-Mail"),
                      ),
                      TextFormField(
                        validator: (val) {
                          return val.length < 6
                              ? "Enter Password 6+ characters"
                              : null;
                        },
                        obscureText: true,
                        controller: passwordTextEditingController,
                        decoration: textFieldInputDecoration("Password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: Text("Forgot Password??"),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  child: Text(
                    "Sign In ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    signIn();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account??"),
                    TextButton(
                        onPressed: () {
                          widget.toggle();
                        },
                        child: Text("Register Now")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
