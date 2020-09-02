import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nitrous/Test/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static bool loggedIn = false;
  static final _fireStore = FirebaseFirestore.instance;

  static Future<bool> signup(
      {email, password, context, userName, jobTitle}) async {
    bool _signedUp = true;
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on PlatformException catch (e) {
      _signedUp = false;
      alertDialog(context, e.message);
    } on Exception catch (e) {
      _signedUp = false;
      alertDialog(context, e);
    }
    if (_signedUp) {
      await _fireStore
          .collection('Nitrous')
          .doc("Users")
          .collection(email)
          .doc("info")
          .set({
        "email": email,
        "userName": userName,
        "jobTitle": jobTitle,
        "imgUrl": "",
        "class1": 0,
        "class2": 0,
        "class3": 0,
        "class4": 0,
        "class5": 0,
        "class6": 0,
      });

      await _fireStore
          .collection('Nitrous')
          .doc("Users")
          .collection("Users")
          .add({"email": email});

        await _fireStore
            .collection('Nitrous')
            .doc("Users")
            .collection(email)
            .doc("classes")
            .collection("Learn")
            .doc()
            .set({
          "topicName": "Nitrous",
          "factor": 1,
          "classnumber": 1,
        });
    }
    return _signedUp;
  }

  static Future<bool> login({email, password, context}) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user.email != null) {
          loggedIn = true;
        }
      });
    } on PlatformException catch (e) {
      alertDialog(context, e.message);
    } on Exception catch (e) {
      alertDialog(context, e);
    }
    return loggedIn;
  }

  static signOut(context) async {
    await _auth.signOut();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("UID", null);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
  }

  static adminSignOut(context) async {
    await _auth.signOut();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool("admin", null);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
  }

  static alertDialog(BuildContext context, message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error occured"),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
          elevation: 5,
        );
      },
    );
  }
}