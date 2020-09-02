import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitrous/Test/screens/home_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth.dart';

class SignUpScreenModel {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  Future<bool> signup(context) async {
    final done = await Auth.signup(
        email: email.text,
        password: password.text,
        context: context,
        userName: userName.text,
        jobTitle: jobTitle.text);
    if (done) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString("UID", email.text);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(
                userEmail: email.text,
              )));
    }
    return done;
  }
}
