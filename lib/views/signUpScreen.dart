import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letschat/Widgets/widgets.dart';
import 'package:letschat/helper/helperFunction.dart';
import 'package:letschat/services/auth.dart';
import 'package:letschat/services/database.dart';
import 'chatRoomScreen.dart';

class SignUpScreen extends StatefulWidget {
  final Function toggleView;
  SignUpScreen(this.toggleView);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isloading = false;

  //Form Key generated for FORM used for validating inputs
  final formKey = GlobalKey<FormState>();

  //TextEditingController is used to control inputs of email id and password and also is used
  //to send email id and password to next page
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailIDTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  //SignMeUp is created to validate input given by user everytime when he
  // presses SIGNIN BUTTONS(onTap).
  void SignMeUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });

      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailIDTextEditingController.text,
      };

      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(
          emailIDTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(
          userNameTextEditingController.text);

      databaseMethods.uploadUserInfo(userInfoMap);
      databaseMethods.addUserInfo(userInfoMap);

      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailIDTextEditingController.text,
          password: passwordTextEditingController.text);

      authMethods
          .signInWithYourEmailAndPassword(emailIDTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        print("$value");
      });

      HelperFunctions.saveUserLoggedInSharedPreference(true);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatRoomScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarMain(context),
        body: isloading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Using TExtFOrmFIeld Instead of textField because its easier to save ,reset here
                          SizedBox(
                            height: 120,
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  //Validator is used to validate input like for email and password while
                                  //text editing controller is used for save , reset and sending text to new page
                                  validator: (val) {
                                    return (val.isEmpty || val.length < 4)
                                        ? "Give Input of size greater than 2"
                                        : null;
                                  },
                                  controller: userNameTextEditingController,
                                  decoration:
                                      textFieldInputDecoration("Username"),
                                ),
                                TextFormField(
                                  validator: (val) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(val)
                                        ? null
                                        : "Enter correct email";
                                  },
                                  controller: emailIDTextEditingController,
                                  decoration:
                                      textFieldInputDecoration("E-Mail"),
                                ),
                                TextFormField(
                                  validator: (val) {
                                    return val.length < 6
                                        ? "Enter Password 6+ characters"
                                        : null;
                                  },
                                  obscureText: true,
                                  controller: passwordTextEditingController,
                                  decoration:
                                      textFieldInputDecoration("Password"),
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
                              "Sign Up ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            onPressed: () {
                              SignMeUp();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have account??"),
                              TextButton(
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                  child: Text("Sign In Now")),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
