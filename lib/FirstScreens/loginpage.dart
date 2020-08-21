import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nitrous/Styles/loginbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType {
  login,
  register,

}

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        Future<String> _counter;
        final SharedPreferences prefs = await _prefs;
        String userId = _formType == FormType.register
            ? await widget.auth.createUser(_email+"@nitrous.com", _password)
            : await widget.auth.signIn(_email+"@nitrous.com", _password);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
          _counter = prefs.setString("username", _email).then((bool success) {
            print(_email);
            return _email;
          });
        });
        widget.onSignIn();
      }
      catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void validateAndCreate() async {
    if (validateAndSave()) {
      try {

        DocumentReference documentReference = Firestore.instance
            .collection("Nitrous")
            .document("Actions")
            .collection("Actions")
            .document();
        documentReference.setData({
          "name": _email,
          "image": "https://firebasestorage.googleapis.com/v0/b/nitrous-c7d4f.appspot.com/o/Images%2F80-805068_my-profile-icon-blank-profile-picture-circle-hd.png?alt=media&token=9f6f2461-a225-44f5-a352-4d9fcfdfe36b",
          "title": "",
          "password": _password,
        });


        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        Future<String> _counter;
        final SharedPreferences prefs = await _prefs;
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email+"@nitrous.com", _password)
            : await widget.auth.createUser(_email+"@nitrous.com", _password);
        setState(() {


          _authHint = 'Signed In\n\nUser id: $userId';
          _counter = prefs.setString("username", _email).then((bool success) {
            print(_email);
            return _email;
          });
        });
        widget.onSignIn();
      }
      catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
          SnackBar(
            content: Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  List<Widget> usernameAndPassword() {
    return [
      SizedBox(
        width: 180,
        height: 150,
        child: Image.asset("assets/images/nitrouslogo.png"),
      ),
      padded(child: new TextFormField(
        textAlign: TextAlign.center,
        key: new Key('email'),
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 5.0),
          ),
          labelText: "Email",
          labelStyle: TextStyle(
              color: Colors.black
          ),
          enabledBorder:  const OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
            borderSide: const BorderSide(color: Colors.black),
          ),  //fillColor: Colors.green
        ),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val,
      )),
      padded(child: new TextFormField(
        key: new Key('password'),
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 5.0),
          ),
          labelText: "Password",
          labelStyle: TextStyle(
              color: Colors.black
          ),
          enabledBorder:  const OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
            borderSide: const BorderSide(color: Colors.black),
          ),  //fillColor: Colors.green
        ),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => _password = val,
      )),
    ];

  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          new Padding(padding: const EdgeInsets.only(left: 56, right: 16,top: 50)),
          new PrimaryButton(
              key: new Key('login'),
              text: 'Login',
              height: 44.0,
              onPressed: validateAndSubmit
          ),
          new FlatButton(
              key: new Key('need-account'),
              child: new Text("Need an account? Register"),
              onPressed: moveToRegister
          ),
        ];
      case FormType.register:
        return [
          new PrimaryButton(
              key: new Key('register'),
              text: 'Create an account',
              height: 44.0,
              onPressed: validateAndCreate
          ),
          new FlatButton(
              key: new Key('need-login'),
              child: new Text("Have an account? Login"),
              onPressed: moveToLogin
          ),
        ];
    }
    return null;
  }

  Widget hintText() {
    return new Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(
            _authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center)
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.fill)),
          child: new SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.only(top: 40),
              child: Container(

                  padding: const EdgeInsets.all(16.0),
                  child: new Column(
                      children: [
                        new Card(
                            child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(color: Colors.white60)
                                      ),
                                      padding: const EdgeInsets.all(16.0),
                                      child: new Form(
                                          key: formKey,
                                          child: new Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: usernameAndPassword() + submitWidgets(),
                                          )
                                      )
                                  ),
                                ])
                        ),
                        hintText()
                      ]
                  )
              ),)),)
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}