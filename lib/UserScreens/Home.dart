import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nitrous/FirstScreens/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';


class HomeScreen extends StatefulWidget {

  HomeScreen({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  String topic = "Time Documentation";
  String subTopic = "Learn";
  String topicname;
  String powerbar;
  int factor;
  bool breakTime = false;

  final _firestore = Firestore.instance;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _counter;
  Future<int> onoff;
  File _image;

  // Pagination
  List<DocumentSnapshot> _actions = [];
  bool loading = true;
  int perpage = 20;
  DocumentSnapshot lastdocument;
  ScrollController _scrollconto = ScrollController();
  bool _getMoreAct = false;
  bool _getAvailableActions = true;

  _getActions() async{
    Query q = _firestore.collection('Nitrous')
        .document("Actions")
        .collection("Actions")
        .orderBy('formattedDate', descending: true).limit(perpage);
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await q.getDocuments();
    _actions = querySnapshot.documents;
    lastdocument = querySnapshot.documents[querySnapshot.documents.length-1];
    setState(() {
      loading = false;
    });
  }

  _getMoreActions() async{

    _getMoreAct = true;
    Query q = _firestore.collection('Nitrous')
        .document("Actions")
        .collection("Actions")
        .orderBy('formattedDate', descending: true).startAfter([lastdocument]).limit(perpage);

    QuerySnapshot querySnapshot = await q.getDocuments();

    if(querySnapshot.documents.length < perpage)
    {
      _getMoreAct = false;
    }
    _actions.addAll(querySnapshot.documents);

    setState(() {
      _getMoreAct = false;
    });
  }

  // Pagination end

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image as File;
    });
  }

  Future uploadPic(BuildContext context) async{
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("Users").child("Images");
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    String url = (await firebaseStorageRef.getDownloadURL()).toString();


    setState(() {
      print("Profile Picture uploaded");
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

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
    _scrollconto.addListener(()
    {
      double maxscroll = _scrollconto.position.maxScrollExtent;
      double currentscroll = _scrollconto.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.2 *0.25;
      if (maxscroll - currentscroll < delta)
        {
          _getMoreActions();
        }
    });
    _counter = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('username'));
    }
    );


    setState(() {

      onoff = _prefs.then((SharedPreferences prefs) {

        return (prefs.getInt('onoff'));
      }
      );
    });


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
                onPressed: _signOut,
              ),
              title: Text('Settings'),
              onTap: null,
            ),
            ListTile(
              leading: new IconButton(
                icon: new Icon(Icons.exit_to_app, color: Colors.black),
                onPressed: _signOut,
              ),
              title: Text('Logout'),
              onTap: _signOut,
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
            FutureBuilder<String>(
              future: _counter,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    print("Fail");
                    return const CircularProgressIndicator();
                  default:
                    return Column(
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance.collection('Nitrous').document("Users").collection(snapshot.data).document("info").snapshots(), //retorna un Stream<DocumentSnapshot>
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return new Center(child: new Text('Loading...'));
                              }
                              var userDocument = snapshot.data;
                              return new Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
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
                                            padding: const EdgeInsets.only(top: 10, left: 20),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                userDocument["name"],
                                                style: TextStyle(
                                                  fontFamily: 'Modak',
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10, left: 20),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                userDocument["title"],
                                                style: TextStyle(
                                                  fontFamily: 'Modak',
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 150, left: 230),
                                      child: new Container(
                                        width: 90.0,
                                        height: 90.0,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(userDocument["image"]),
                                        ),
                                      )),
                                ],
                              );
                            }
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Activity',
                                style: TextStyle(
                                  fontFamily: 'Modak',
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        FutureBuilder<int>(
                            future: onoff,
                            builder: (BuildContext context, AsyncSnapshot<int> snapshots) {
                              switch (snapshots.connectionState) {
                                case ConnectionState.waiting:
                                  return const CircularProgressIndicator();
                                default:
                                  if (snapshots.data == 1)
                                  {
                                    return  Padding(
                                      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.white)),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 20, right: 20, left: 20),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      'Currently you are doing...',
                                                      style: TextStyle(
                                                        fontFamily: 'Modak',
                                                        fontSize: 24,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20),
                                                  child: Container(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                      height: MediaQuery.of(context).size.height * 0.2,
                                                      decoration:
                                                      BoxDecoration(border: Border.all(color: Colors.black)),
                                                      child: _actions.length == 0 ? Center(child: Text('No Actions yet'),)
                                                          :ListView.builder(
                                                        itemBuilder: (_, index) {
                                                          var color = (_actions[index].data["status"] == "Ongoing")
                                                              ? Colors.green
                                                              : Colors.red;
                                                          return Padding(
                                                            padding: const EdgeInsets.only(bottom: 8.0,top: 8.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Container(
                                                                  height: 15,
                                                                  width: 20,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle, color: color),
                                                                ),
                                                                Text(
                                                                  _actions[index].data["topic"],
                                                                  style: TextStyle(color: color),
                                                                ),
                                                                Text(_actions[index].data["subTopic"],
                                                                    style: TextStyle(color: color)),
                                                                Text(_actions[index].data["title"],
                                                                    style: TextStyle(color: color)),
                                                                Text(_actions[index].data["status"],
                                                                    style: TextStyle(color: color)),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        itemCount: _actions.length,
                                                        controller: _scrollconto,
                                                      )
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text("End"),
                                                    Switch(
                                                        value: true,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            showDialog(
                                                                context: context,
                                                                builder:(BuildContext context)
                                                                {
                                                                  return Dialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        BorderRadius.circular(20.0)), //this right here
                                                                    child: Container(
                                                                      height: 200,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(12.0),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Center(child:Text("Are you sure") ,),
                                                                            SizedBox(
                                                                              width: 320.0,
                                                                              child: Column(
                                                                                children: [
                                                                                  RaisedButton(
                                                                                    onPressed: () async {
                                                                                      updateTopic();
                                                                                      off();
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text(
                                                                                      "Yes",
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                                    color: const Color(0xFF1BC0C5),
                                                                                  ),
                                                                                  RaisedButton(
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text(
                                                                                      "No",
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                                    color: const Color(0xFF1BC0C5),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                            );

                                                          });
                                                        }),
                                                    Text("Start")
                                                  ],
                                                ),
                                                Text("Break"),
                                                Container(
                                                  margin: EdgeInsets.symmetric(vertical: 10),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle, color: Colors.blue),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      breakTime ? Icons.pause : Icons.play_arrow,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {

                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  else {
                                    return  Padding(
                                      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.white)),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 20, right: 20, left: 20),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      'Pick Topic...',
                                                      style: TextStyle(
                                                        fontFamily: 'Modak',
                                                        fontSize: 24,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20),
                                                  child: Container(
                                                    padding: const EdgeInsets.only(right: 5,left: 5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.black)),
                                                    child: Column(children: <Widget>[
                                                      DropdownButton(
                                                          value: topic,
                                                          items: [
                                                            DropdownMenuItem(
                                                              child: Text("Time Documentation"),
                                                              value: "Time Documentation",
                                                            ),
                                                          ],
                                                          onChanged: (value) {
                                                            topic = value;
//notifyListeners();
                                                          }),
                                                      DropdownButton(
                                                          value: subTopic,
                                                          items: [
                                                            DropdownMenuItem(
                                                              child: Text("Learn"),
                                                              value: "Learn",
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text("Teach"),
                                                              value: "Teach",
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text("Break"),
                                                              value: "Break",
                                                            ),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              subTopic = value;
                                                            });
                                                          }),
                                                      StreamBuilder<QuerySnapshot>(
                                                          stream: Firestore.instance.collection('Nitrous').document('Users').collection(snapshot.data).document('Topics').collection(subTopic).snapshots(),
                                                          builder: (context, snap) {
                                                            if(snap.data == null) return CircularProgressIndicator();

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
                                                                items: snap.data.documents.map((
                                                                    DocumentSnapshot document) {
                                                                  return new DropdownMenuItem<
                                                                      String>(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          powerbar = document
                                                                              .data['catagory'];
                                                                          factor =
                                                                          document.data['value'];
                                                                        });
                                                                      },
                                                                      value: document
                                                                          .data['name'],
                                                                      child: new Text(
                                                                        document.data['name'],
                                                                        textAlign: TextAlign
                                                                            .center,)
                                                                  );
                                                                }).toList(),
                                                              );
                                                            }
                                                          }
                                                      ),

                                                    ],),),
                                                ),
                                                FlatButton.icon(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.add),
                                                    label: Text("Add topic")),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text("End"),
                                                    Switch(
                                                        value: false,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            {
                                                              showDialog(
                                                                  context: context,
                                                                  builder:(BuildContext context)
                                                                  {
                                                                    return Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(20.0)), //this right here
                                                                      child: Container(
                                                                        height: 200,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(12.0),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Center(child:Text("Are you sure") ,),
                                                                              SizedBox(
                                                                                width: 320.0,
                                                                                child: Column(
                                                                                  children: [
                                                                                    RaisedButton(
                                                                                      onPressed: () async {

                                                                                        onn();
                                                                                        DateTime now = DateTime.now();
                                                                                        String Year = DateFormat('yy').format(now);
                                                                                        String Month = DateFormat('MM').format(now);
                                                                                        String Day = DateFormat('dd').format(now);

                                                                                        String Hour = DateFormat('kk').format(now);
                                                                                        String Min = DateFormat('mm').format(now);

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

                                                                                        DocumentReference documentReference = _firestore
                                                                                            .collection("Nitrous")
                                                                                            .document("Actions")
                                                                                            .collection("Actions")
                                                                                            .document();
                                                                                        documentReference.setData({
                                                                                          "id": documentReference.documentID,
                                                                                          "topic": topicname,
                                                                                          "formattedDate": int.parse(formdate),
                                                                                          "powerBar": powerbar,
                                                                                          "subTopic": subTopic,
                                                                                          "title": topic,
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
                                                                                          "userID": snapshot.data
                                                                                        });

                                                                                        uid = pre.setString("uid", documentReference.documentID).then((bool success) {
                                                                                          print(uid);
                                                                                          return uid;
                                                                                        });
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text(
                                                                                        "Yes",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                      color: const Color(0xFF1BC0C5),
                                                                                    ),
                                                                                    RaisedButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text(
                                                                                        "No",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                      color: const Color(0xFF1BC0C5),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                              );
                                                            }
                                                          });
                                                        }),
                                                    Text("Start")
                                                  ],
                                                ),
                                                Text("Break"),
                                                Container(
                                                  margin: EdgeInsets.symmetric(vertical: 10),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle, color: Colors.blue),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      breakTime ? Icons.pause : Icons.play_arrow,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {

                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              }
                            }),
                        Padding(padding: const EdgeInsets.only(top: 20,bottom: 20),
                          child: Text(
                            "PROGRESS",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),),
                        Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration:
                            BoxDecoration(border: Border.all(color: Colors.black)),
                            child: _actions.length == 0 ? Center(child: Text('No Actions yet'),)
                                :ListView.builder(
                              itemBuilder: (_, index) {
                                var color = (_actions[index].data["status"] == "Ongoing")
                                    ? Colors.green
                                    : Colors.red;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0,top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: color),
                                      ),
                                      Text(
                                        _actions[index].data["topic"],
                                        style: TextStyle(color: color),
                                      ),
                                      Text(_actions[index].data["subTopic"],
                                          style: TextStyle(color: color)),
                                      Text(_actions[index].data["title"],
                                          style: TextStyle(color: color)),
                                      Text(_actions[index].data["status"],
                                          style: TextStyle(color: color)),
                                    ],
                                  ),
                                );
                              },
                              itemCount: _actions.length,
                              controller: _scrollconto,
                            )
                        )
                      ],
                    );

                }
              },
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

    int y = int.parse(Year)- year;
    int m = int.parse(Month)- month;
    int d = int.parse(Day)- day;
    int h = (int.parse(Hour)- hour)*60;
    int mi = int.parse(Min)- min;

    if (mi<0)
      {
        mi = mi +60;
      }
    if(h<0)
      {
        h = (h+24);
      }

    int diff = mi+h;
    DocumentReference documentReference = _firestore
        .collection("Nitrous")
        .document("Actions")
        .collection("Actions")
        .document(uid.toString());
    documentReference.updateData({

      "endHour": int.parse(Hour),
      "endMin": int.parse(Min),
      "endMonth": int.parse(Month),
      "endDay": int.parse(Day),
      "endYear": int.parse(Year),
      "duration": diff,
      "status": "Done",
    });

    Navigator.pop(context);


  }


  void _signOut() async {
    widget.auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
          (Route<dynamic> route) => false,
    );  }
}


