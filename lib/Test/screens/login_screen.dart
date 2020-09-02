import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitrous/Test/models/models/auth.dart';
import 'package:nitrous/Test/screens/admin_screens/admin_main_screen.dart';
import 'package:nitrous/Test/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenModel {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<bool> login(context) async {
    bool loggedIn = await Auth.login(
        email: email.text, password: password.text, context: context);
    if (loggedIn) {
      var doc = await FirebaseFirestore.instance
          .collection("Nitrous")
          .doc("Admin")
          .collection("Admin")
          .doc(email.text)
          .get();
      final bool admin = doc.data != null;

      if (admin) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setBool("admin", true);
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminMainPage()));
        return true;
      }

      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString("UID", email.text);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(
            userEmail: email.text,
          )));
    }
    return loggedIn;
  }
}