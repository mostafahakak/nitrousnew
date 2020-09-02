import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nitrous/Test/screens/admin_screens/admin_main_screen.dart';
import 'package:nitrous/Test/screens/home_screen.dart';
import 'package:nitrous/Test/screens/main_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';


String userEmail;
bool admin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  userEmail = _prefs.getString('UID');
  admin = _prefs.getBool('admin') ?? false;
  runApp(MyAppj());
}

class MyAppj extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyAppj> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    print(" main $admin");

    return MaterialApp(
        title: 'Nitrous',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context,snapshot)
          {
            if(snapshot.hasError)
            {
              return Container();
            }
            if(snapshot.connectionState == ConnectionState.done)
            {
              return Scaffold(
                body: userEmail == null
                    ? admin ? AdminMainPage() : MainScreen()
                    : HomeScreen(
                  userEmail: userEmail,
                ),
              );
            }
            return Container();
          },
        )
    );
  }
}