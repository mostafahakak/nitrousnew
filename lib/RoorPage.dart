import 'package:flutter/material.dart';
import 'FirstScreens/auth.dart';
import 'FirstScreens/loginpage.dart';
import 'UserScreens/Home.dart';



class RootPage extends StatefulWidget {
  final BaseAuth auth;
  RootPage({Key key, this.auth}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedInUser,
  signedInAdmin,
}

class _RootPageState extends State<RootPage> {


  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId != null ? AuthStatus.signedInUser : AuthStatus.notSignedIn;
      });
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          title: 'Flutter Login',
          auth: widget.auth,
          onSignIn: () {
            _updateAuthStatus(AuthStatus.signedInUser);
          },
        );
      case AuthStatus.signedInUser:
        return MaterialApp(
          home: HomeScreen(
              auth: widget.auth,
              onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)
          ),
        );
      case AuthStatus.signedInAdmin:
        return null;
    }
  }
}