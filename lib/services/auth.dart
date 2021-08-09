import 'package:firebase_auth/firebase_auth.dart';
import 'package:letschat/models/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //UserModel created to not check for null user from firebase and use only
  // requiered property i.ie UserId from firebase instead of all result.user.

  UserModel _getuserFromFirebaseUser(User user) {
    return user != null ? UserModel(userId: user.uid) : null;
  }

  //Firebase has update FirebaseUser to only User and FirebaseAuth.Result to UserCredential
  Future signInWithYourEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User userFromFirebase = result.user;
      return _getuserFromFirebaseUser(userFromFirebase);
    } catch (e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential createdUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User userCreated = createdUser.user;
      return _getuserFromFirebaseUser(userCreated);
    } catch (e) {
      print(e);
    }
  }

  //ResetPassword
  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  //SignOut
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
