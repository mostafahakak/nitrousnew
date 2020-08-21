import 'package:flutter/material.dart';
import 'FirstScreens/auth.dart';
import 'RoorPage.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        body: new RootPage(auth: new Auth()),
      ),
    );
  }
}