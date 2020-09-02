import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nitrous/Test/models/models/auth.dart';
import 'package:nitrous/Test/screens/admin_screens/ReaustedTopic.dart';
import 'package:nitrous/Test/screens/admin_screens/activity_log_screen.dart';
import 'package:nitrous/Test/screens/admin_screens/dashboard_screen.dart';
import 'package:nitrous/Test/screens/admin_screens/users_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitrous/Test/screens/admin_screens/add_topic_screen.dart';
import 'package:nitrous/Test/screens/admin_screens/admin_addtopic.dart';

class AdminMainPage extends StatefulWidget {

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<AdminMainPage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    subscribeToAdmin();
    getDeviceToken();
    configureCallback();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/admin_background.jpeg"),
                fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 80,
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () => Auth.adminSignOut(context)),

                ],
              ),
              SizedBox(
                height: 10,
              ),
              DefaultTabController(
                length: 4,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      isScrollable: true,
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "ACTIVITY LOG",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "USERS",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "ReqTopics",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "DASHBOARD",
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      height: 500,
                      child: TabBarView(children: [
                        ActivityLogScreen(),
                        UsersScreen(),
                        RequesteTopic(),
                        DashboardScreen()
                      ]),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void configureCallback()
  {
    _firebaseMessaging.configure(
      //when the user is using the app
      onMessage: (message) async
      {

      },
        //whehn the user open the notification
      onResume: (message) async
      {

      },
        //
      onLaunch: (message) async
      {

      }
    );
  }

  void getDeviceToken() async
  {
    String DeviceToken = await _firebaseMessaging.getToken();
  }

  void subscribeToAdmin() 
  {
    _firebaseMessaging.subscribeToTopic('Admin');
  }
}


