import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final model;

  const LoginScreen({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: model.email,
          decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.3, color: Colors.black45),
                  borderRadius: BorderRadius.circular(20))),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        TextFormField(
          controller: model.password,
          obscureText: true,
          decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.3, color: Colors.black45),
                  borderRadius: BorderRadius.circular(20))),
        ),
      ],
    );
  }
}