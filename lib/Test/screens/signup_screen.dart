import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  final model;

  const SignupScreen({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: model.userName,
          decoration: InputDecoration(
              labelText: "Username",
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.3, color: Colors.black45),
                  borderRadius: BorderRadius.circular(20))),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        TextFormField(
          controller: model.jobTitle,
          decoration: InputDecoration(
              labelText: "Job title",
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.3, color: Colors.black45),
                  borderRadius: BorderRadius.circular(20))),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        TextFormField(
          controller: model.email,
          decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.3, color: Colors.black45),
                  borderRadius: BorderRadius.circular(20))),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
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
