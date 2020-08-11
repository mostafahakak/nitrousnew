import 'package:flutter/material.dart';
import 'package:nitrous/FirstScreens/auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';



class HomeUser extends StatefulWidget
{
  HomeUser({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;


  MyAppState createState() => MyAppState();

}


class MyAppState extends State<HomeUser>
    with SingleTickerProviderStateMixin {

  ScrollController _scrollViewController;
  int _selectedTab = 0;
  final _pageOptions = [
    ProfilePage(),
    Kcloud(),
    ProcessPage(),
    MyApps(),
    MeetingPage()
  ];

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text("Mostafa.ashraf.93@gmail.com"),
              accountName: Text("Mostafa Ashraf"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: new IconButton(
                icon: new Icon(Icons.home, color: Colors.black),
                onPressed: () => null,
              ),
              title: Text('Home'),
              onTap: null,
            ),
            ListTile(
              leading: new IconButton(
                icon: new Icon(Icons.settings, color: Colors.black),
                onPressed:_signOut,
              ),
              title: Text('Settings'),
              onTap: null,
            ),
          ],
        ),
      ),
      body: _pageOptions[_selectedTab] ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (int index) {
          setState(() {
            _selectedTab = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.black),
            title: Text('Home',style: TextStyle(
              color: Colors.black,
            ),),
          ),
          BottomNavigationBarItem(
            //backgroundColor: Colors.black,
            icon: Icon(MyFlutterApp.cloud,color: Colors.black),
            title: Text('Kcloud',style: TextStyle(
              color: Colors.black,
            )),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,color: Colors.black),
            title: Text('Process',style: TextStyle(
              color: Colors.black,
            )),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,color: Colors.black),
            title: Text('Tasks',style: TextStyle(
              color: Colors.black,
            )),
          ),
          BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.meeting,color: Colors.black),
            title: Text('Meetings',style: TextStyle(
              color: Colors.black,
            )),
          ),

        ],
      ),
    );
  }


  void _signOut() async {
    widget.auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
          (Route<dynamic> route) => false,
    );  }

}
