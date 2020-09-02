import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nitrous/Test/models/models/auth.dart';
import 'package:nitrous/Test/screens/main_screen.dart';
import 'package:nitrous/UserScreens/EditInfo.dart';
import 'package:nitrous/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final userEmail;

  const HomeScreen({Key key, this.userEmail}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String topic,username;
  int  classnum;
  var actionTopic;
  String topicname;
  String firstClassNum = "Learn";
  String powerbar;
  int factor;

  bool breakTime = false;

  final _firestore = FirebaseFirestore.instance;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<int> onoff;

  // Pagination
  List<DocumentSnapshot> _actions = [];
  bool loading = true;
  int perpage = 10;
  DocumentSnapshot lastdocument;
  ScrollController _scrollconto = ScrollController();
  bool _getMoreAct = false;
  bool _getAvailableActions = true;

  _getActions() async {
    print(widget.userEmail);

    Query q = _firestore
        .collection('Nitrous')
        .doc("Actions")
        .collection("Actions")
        .where("userID", isEqualTo: widget.userEmail)
        .orderBy('formattedDate', descending: true)
        .limit(perpage);
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _actions = querySnapshot.docs;
    lastdocument = querySnapshot.docs[querySnapshot.docs.length-1];
    setState(() {
      loading = false;
    });
  }

  _getMoreActions() async {
    _getMoreAct = true;
    Query q = _firestore
        .collection('Nitrous')
        .document("Actions")
        .collection("Actions")
        .where("userID", isEqualTo: widget.userEmail)
        .orderBy('formattedDate', descending: true)
        .startAfter([lastdocument]).limit(perpage);

    QuerySnapshot querySnapshot = await q.getDocuments();

    if (querySnapshot.docs.length < perpage) {
      _getMoreAct = false;
    }
    _actions.addAll(querySnapshot.documents);

    setState(() {
      _getMoreAct = false;
    });
  }

  // Pagination end

  Future<void> off() async {
    final SharedPreferences prefs = await _prefs;
    final int sw = 0;

    setState(() {
      onoff = prefs.setInt("onoff", sw).then((bool success) {
        return sw;
      });
    });
  }

  Future<void> onn() async {
    final SharedPreferences prefs = await _prefs;
    final int sw = 1;

    setState(() {
      onoff = prefs.setInt("onoff", sw).then((bool success) {
        return sw;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getActions();
    _scrollconto.addListener(() {
      double maxscroll = _scrollconto.position.maxScrollExtent;
      double currentscroll = _scrollconto.position.pixels;
      double delta = (MediaQuery.of(context).size.height * 0.2) * 0.25;

      if (maxscroll - currentscroll < delta) {
        _getMoreActions();
      }
    });

    onoff = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('onoff'));
    });
    setState(() {});
  }

  @override
  void dispose() {
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
              accountEmail: Text(""),
              accountName: Text(""),
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
                onPressed: () => Auth.signOut(context),
              ),
              title: Text('Settings'),
              onTap: null,
            ),
            ListTile(
              leading: new IconButton(
                icon: new Icon(Icons.exit_to_app, color: Colors.black),
                onPressed: () {
                  Auth.signOut(context);
                },
              ),
              title: Text('Logout'),
              onTap: () {
                Auth.signOut(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill)),
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      onPressed: () => Auth.signOut(context)),
                ),

                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Nitrous')
                        .doc("Users")
                        .collection(widget.userEmail)
                        .doc("info")
                        .snapshots(), //retorna un Stream<DocumentSnapshot>
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return new Center(child: new Text('Loading...'));
                      }

                      var userDocument = snapshot.data;
                      username = userDocument.data()["userName"];

                      return new Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 20, left: 20),
                            child: Container(
                              width: 500,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white)),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: Text(
                                      userDocument.data()["userName"],
                                      style: TextStyle(
                                        fontFamily: 'Modak',
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: Text(
                                      userDocument.data()["jobTitle"],
                                      style: TextStyle(
                                        fontFamily: 'Modak',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                              padding:
                              const EdgeInsets.only(top: 120, left: 230),
                              child: new Container(
                                width: 90.0,
                                height: 90.0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => EditInfo()));
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                        userDocument.data()["imgUrl"]),
                                  ),
                                ),
                              )),
                        ],
                      );

                    }),

                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Card(
                      shape: Border(
                          right: BorderSide(color: Colors.white, width: 5)),
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 20, right: 20, left: 20),
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      topicname = null;
                                      firstClassNum = "Learn";
                                    });

                                  }, // handle your image tap here
                                  child: Image.asset(
                                    'assets/images/learn.png',
                                    fit: BoxFit.cover, // this is the solution for border
                                    width: 80.0,
                                    height: 80.0,
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.only(left: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        topicname = null;
                                        firstClassNum = "Implement";
                                      });
                                    }, // handle your image tap here
                                    child: Image.asset(
                                      'assets/images/impelement.png',
                                      fit: BoxFit.cover, // this is the solution for border
                                      width: 80.0,
                                      height: 80.0,
                                    ),
                                  ),),
                                Padding(padding: const EdgeInsets.only(left: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        topicname = null;
                                        firstClassNum = "Teach";
                                      });
                                    }, // handle your image tap here
                                    child: Image.asset(
                                      'assets/images/teach.png',
                                      fit: BoxFit.cover, // this is the solution for border
                                      width: 80.0,
                                      height: 80.0,
                                    ),
                                  ),),
                              ],
                            ),

                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Nitrous')
                                    .doc("Users")
                                    .collection(widget.userEmail)
                                    .doc("classes")
                                    .collection(firstClassNum)
                                    .snapshots(),
                                builder: (context, snap) {
                                  if (snap.data == null)
                                    return Container();
                                  else {
                                    return new DropdownButton<String>(
                                      hint: new Text('Pick topic'),
                                      value: topicname,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          topicname = newValue;
                                          print(topicname);

                                        });
                                      },
                                      items: snap.data.docs.map(
                                              (DocumentSnapshot document) {
                                            return new DropdownMenuItem<
                                                String>(
                                                onTap: () {
                                                  setState(() {
                                                    actionTopic =
                                                        document.data;

                                                    factor = document
                                                        .data()["factor"];
                                                    classnum = document
                                                        .data()["classnumber"];
                                                  });
                                                },
                                                value: document
                                                    .data()['topicName'],
                                                child: new Text(
                                                  document
                                                      .data()['topicName'],
                                                  textAlign:
                                                  TextAlign.center,
                                                ));
                                          }).toList(),
                                    );
                                  }
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("End"),
                                FutureBuilder<int>(
                                    future: onoff,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<int> snapshots) {
                                      switch (snapshots.connectionState) {
                                        case ConnectionState.waiting:
                                          return const CircularProgressIndicator();
                                        default:
                                          if (snapshots.data == 1) {
                                            return Switch(
                                                value: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    updateTopic();
                                                    off();
                                                    _actions.clear();
                                                    _getActions();
                                                  });
                                                });
                                          } else {
                                            return Switch(
                                                value: false,
                                                onChanged: (value) {
                                                  setState(() async {
                                                    {

                                                      if (topicname == null || firstClassNum == null) return;
                                                      onn();
                                                      DateTime now = DateTime.now();
                                                      String Year = DateFormat('yy').format(now);
                                                      String Month = DateFormat('MM').format(now);
                                                      String Day = DateFormat('dd').format(now);

                                                      String Hour = DateFormat('kk').format(now);
                                                      String Min = DateFormat('mm').format(now);
                                                      String ss = DateFormat('ss').format(now);

                                                      String formdate = DateFormat('yyMMdd').format(now);

                                                      SharedPreferences pre = await SharedPreferences.getInstance();
                                                      Future<int> day;
                                                      Future<int> year;
                                                      Future<int> min;
                                                      Future<int> month;
                                                      Future<int> hour;
                                                      Future<int> uid;

                                                      day = pre.setInt("day", int.parse(Day)).then((bool success) {
                                                        print(day);
                                                        return day;
                                                      });

                                                      year = pre.setInt("year", int.parse(Year)).then((bool success) {
                                                        print(year);
                                                        return year;
                                                      });

                                                      min = pre.setInt("min", int.parse(Min)).then((bool success) {
                                                        print(min);
                                                        return min;
                                                      });

                                                      month = pre.setInt("month", int.parse(Month)).then((bool success) {
                                                        print(month);
                                                        return month;
                                                      });

                                                      hour = pre.setInt("hour", int.parse(Hour)).then((bool success) {
                                                        print(hour);
                                                        return hour;
                                                      });

                                                      DocumentReference documentReference = _firestore.collection("Nitrous").doc("Actions").collection("Actions").doc(Year + Month + Day + Hour + Min + ss);
                                                      documentReference.set({
                                                        "id": Year + Month + Day + Hour + Min + ss,
                                                        "topic": topicname,
                                                        "formattedDate": int.parse(formdate),
                                                        "powerBar": classnum,
                                                        "username": username,
                                                        "title": firstClassNum,
                                                        "startHour": int.parse(Hour),
                                                        "endHour": 0,
                                                        "startMin": int.parse(Min),
                                                        "endMin": 0,
                                                        "startMonth": int.parse(Month),
                                                        "endMonth": 0,
                                                        "startDay": int.parse(Day),
                                                        "endDay": 0,
                                                        "startYear": int.parse(Year),
                                                        "endYear": 0,
                                                        "duration": 0,
                                                        "factor": factor,
                                                        "status": "Ongoing",
                                                        "userID": widget.userEmail
                                                      });

                                                      uid = pre.setString("uid", Year + Month + Day + Hour + Min + ss).then((bool success) {
                                                        print(uid);
                                                        return uid;
                                                      });

                                                      _actions.clear();
                                                      _getActions();
                                                    }
                                                  });
                                                });
                                          }
                                      }
                                    }),
                                Text("Start")
                              ],
                            ),
                            FutureBuilder<int>(
                                future: onoff,
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> sb) {
                                  switch (sb.connectionState) {
                                    case ConnectionState.waiting:
                                      return const CircularProgressIndicator();
                                    default:
                                      if (sb.data == 1) {
                                        return Container();
                                      } else {
                                        return Column(
                                          children: [
                                            Text("Break"),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.blue),
                                              child: IconButton(
                                                icon: Icon(
                                                  breakTime
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                      context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  20.0)), //this right here
                                                          child: Container(
                                                            height: 200,
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  12.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Center(
                                                                    child: Text(
                                                                        "Are you sure"),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                    320.0,
                                                                    child:
                                                                    Column(
                                                                      children: [
                                                                        RaisedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            onn();
                                                                            DateTime
                                                                            now =
                                                                            DateTime.now();
                                                                            String
                                                                            Year =
                                                                            DateFormat('yy').format(now);
                                                                            String
                                                                            Month =
                                                                            DateFormat('MM').format(now);
                                                                            String
                                                                            Day =
                                                                            DateFormat('dd').format(now);

                                                                            String
                                                                            Hour =
                                                                            DateFormat('kk').format(now);
                                                                            String
                                                                            Min =
                                                                            DateFormat('mm').format(now);
                                                                            String
                                                                            ss =
                                                                            DateFormat('ss').format(now);

                                                                            String
                                                                            formdate =
                                                                            DateFormat('yyMMdd').format(now);

                                                                            SharedPreferences
                                                                            pre =
                                                                            await SharedPreferences.getInstance();
                                                                            Future<int>
                                                                            day;
                                                                            Future<int>
                                                                            year;
                                                                            Future<int>
                                                                            min;
                                                                            Future<int>
                                                                            month;
                                                                            Future<int>
                                                                            hour;
                                                                            Future<int>
                                                                            uid;

                                                                            day =
                                                                                pre.setInt("day", int.parse(Day)).then((bool success) {
                                                                                  print(day);
                                                                                  return day;
                                                                                });

                                                                            year =
                                                                                pre.setInt("year", int.parse(Year)).then((bool success) {
                                                                                  print(year);
                                                                                  return year;
                                                                                });

                                                                            min =
                                                                                pre.setInt("min", int.parse(Min)).then((bool success) {
                                                                                  print(min);
                                                                                  return min;
                                                                                });

                                                                            month =
                                                                                pre.setInt("month", int.parse(Month)).then((bool success) {
                                                                                  print(month);
                                                                                  return month;
                                                                                });

                                                                            hour =
                                                                                pre.setInt("hour", int.parse(Hour)).then((bool success) {
                                                                                  print(hour);
                                                                                  return hour;
                                                                                });

                                                                            DocumentReference documentReference = _firestore.collection("Nitrous").doc("Actions").collection("Actions").doc(Year +
                                                                                Month +
                                                                                Day +
                                                                                Hour +
                                                                                Min +
                                                                                ss);
                                                                            documentReference.set({
                                                                              "id": Year + Month + Day + Hour + Min + ss,
                                                                              "topic": "Break",
                                                                              "formattedDate": int.parse(formdate),
                                                                              "powerBar": 0,
                                                                              "userName": username,
                                                                              "title": "Break",
                                                                              "startHour": int.parse(Hour),
                                                                              "endHour": 0,
                                                                              "startMin": int.parse(Min),
                                                                              "endMin": 0,
                                                                              "startMonth": int.parse(Month),
                                                                              "endMonth": 0,
                                                                              "startDay": int.parse(Day),
                                                                              "endDay": 0,
                                                                              "startYear": int.parse(Year),
                                                                              "endYear": 0,
                                                                              "duration": 0,
                                                                              "factor": 1,
                                                                              "status": "Ongoing",
                                                                              "userID": widget.userEmail
                                                                            });

                                                                            uid =
                                                                                pre.setString("uid", Year + Month + Day + Hour + Min + ss).then((bool success) {
                                                                                  print(uid);
                                                                                  return uid;
                                                                                });

                                                                            _actions.clear();
                                                                            _getActions();
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                          Text(
                                                                            "Yes",
                                                                            style:
                                                                            TextStyle(color: Colors.white),
                                                                          ),
                                                                          color:
                                                                          const Color(0xFF1BC0C5),
                                                                        ),
                                                                        RaisedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                          Text(
                                                                            "No",
                                                                            style:
                                                                            TextStyle(color: Colors.white),
                                                                          ),
                                                                          color:
                                                                          const Color(0xFF1BC0C5),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                  }
                                }),

                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Name",
                                    style: TextStyle(color: Colors.black,fontSize: 11),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  width: 50,
                                  child: Text(
                                    "Action",
                                    style: TextStyle(color: Colors.black,fontSize: 11),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  width: 50,
                                  child: Text(
                                    "Topic",
                                    style: TextStyle(color: Colors.black,fontSize: 11),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  child: Text(
                                    "Start",
                                    style: TextStyle(color: Colors.black,fontSize: 11),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Time",
                                    style: TextStyle(color: Colors.black,fontSize: 11),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Date",
                                    style: TextStyle(color: Colors.black,fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 50),
                              child: Container(
                                  width: MediaQuery.of(context).size.width ,
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  child: _actions.length == 0
                                      ? Center(
                                    child: Text('No Actions yet'),
                                  )
                                      : StreamBuilder(
                                      stream: _firestore
                                          .collection('Nitrous')
                                          .doc("Actions")
                                          .collection("Actions")
                                          .where("userID", isEqualTo: widget.userEmail)
                                          .snapshots(),
                                      builder: (ctx, snap) {
                                        return ListView.builder(
                                          itemBuilder: (_, index) {
                                            var color = (_actions[index].data()["status"] ==
                                                "Ongoing")
                                                ? Colors.green
                                                : Colors.red;
                                            return Container(
                                              color: !(index % 2 == 0)
                                                  ? Colors.transparent
                                                  : Colors.black12,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                                    child: Text(
                                                      _actions[index]
                                                          .data()["userID"]
                                                          .toString()
                                                          .substring(0, 6),
                                                      style:
                                                      TextStyle(color: Colors.black, fontSize: 11),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                                    child: Text(
                                                      _actions[index].data()["title"].substring(0,1),
                                                      style:
                                                      TextStyle(color: Colors.black, fontSize: 11),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                                    width: 50,
                                                    child: Text(
                                                      _actions[index].data()["topic"],
                                                      style:
                                                      TextStyle(color: Colors.black, fontSize: 11),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    padding: EdgeInsets.symmetric(horizontal: 3),
                                                    child: Text(
                                                      "${_actions[index].data()["startHour"]}:${_actions[index].data()["startMin"]}",
                                                      style: TextStyle(color: Colors.black, fontSize: 11),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 40,
                                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                                    child: Text(
                                                      (_actions[index].data()["status"] == "Done")
                                                          ? "${_actions[index].data()["duration"]}"
                                                          : "--",
                                                      style: TextStyle(color: Colors.black, fontSize: 11),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 40,
                                                    padding: EdgeInsets.only(left: 8),
                                                    child: Text(
                                                      "${_actions[index].data()["startDay"]}/${_actions[index].data()["startMonth"]}/${_actions[index].data()["startYear"]}",
                                                      style:
                                                      TextStyle(color: Colors.black, fontSize: 11),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount: _actions.length,
                                          controller: _scrollconto,
                                        );
                                      })),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateTopic() async {
    DateTime now = DateTime.now();
    String Year = DateFormat('yy').format(now);
    String Month = DateFormat('MM').format(now);
    String Day = DateFormat('dd').format(now);

    String Hour = DateFormat('kk').format(now);
    String Min = DateFormat('mm').format(now);

    SharedPreferences pre = await SharedPreferences.getInstance();
    int day;
    int year;
    int min;
    int month;
    int hour;
    String uid;

    day = pre.getInt('day');
    year = pre.getInt('year');
    min = pre.getInt('min');
    month = pre.getInt('month');
    hour = pre.getInt('hour');

    uid = pre.getString('uid');
    print(uid);

    int y = int.parse(Year) - year;
    int m = int.parse(Month) - month;
    int d = int.parse(Day) - day;
    int h = (int.parse(Hour) - hour) * 60;
    int mi = int.parse(Min) - min;

    if (mi < 0) {
      mi = mi + 60;
    }
    if (h < 0) {
      h = (h + 24);
    }

    int diff = mi + h;
    DocumentReference documentReference = _firestore
        .collection("Nitrous")
        .doc("Actions")
        .collection("Actions")
        .doc(uid.toString());
    documentReference.update({
      "endHour": int.parse(Hour),
      "endMin": int.parse(Min),
      "endMonth": int.parse(Month),
      "endDay": int.parse(Day),
      "endYear": int.parse(Year),
      "duration": diff,
      "status": "Done",
    });
  }
}



/*ExpansionTile(
                              backgroundColor: Colors.white10,
                              title: new Text("Learn",
                                style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.black),),
                              children: <Widget>[
                                new Column(children: [
                                  StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance
                                          .collection('Nitrous')
                                          .document("Users")
                                          .collection(widget.userEmail)
                                          .document("classes")
                                          .collection("Learn")
                                          .snapshots(),
                                      builder: (context, snap) {
                                        if (snap.data == null)
                                          return CircularProgressIndicator();
                                        else {
                                          return new DropdownButton<String>(
                                            hint: new Text('Pick topic'),
                                            value: topicname,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                firstClassNum = "Learn";
                                                topicname = null;
                                                topicname = newValue;
                                                print(topicname);
                                              });
                                            },
                                            items: snap.data.documents.map(
                                                    (DocumentSnapshot document) {
                                                  return new DropdownMenuItem<
                                                      String>(
                                                      onTap: () {
                                                        setState(() {
                                                          actionTopic =
                                                              document.data;
                                                          factor = document
                                                              .data["factor"];
                                                          classnum = document
                                                              .data["classnumber"];
                                                        });
                                                      },
                                                      value: document
                                                          .data['topicName'],
                                                      child: new Text(
                                                        document
                                                            .data['topicName'],
                                                        textAlign:
                                                        TextAlign.center,
                                                      ));
                                                }).toList(),
                                          );
                                        }
                                      })
                                  ,
                                ],
                                ),
                              ],
                            ),
                          */