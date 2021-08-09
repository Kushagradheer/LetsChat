import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text("Flutter Chat App"),
    backgroundColor: Colors.blue[800],
    centerTitle: true,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black45),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)));
}
