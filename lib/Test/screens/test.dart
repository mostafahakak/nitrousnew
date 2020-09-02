import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/models/user.dart';

class Test extends StatelessWidget {
  final user = User(email: "test");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: RaisedButton(
          onPressed: () {},
          child: Text("upload"),
        ),
      ),
    );
  }
}
