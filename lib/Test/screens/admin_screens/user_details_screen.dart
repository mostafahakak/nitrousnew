import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitrous/Test/screens/admin_screens/add_topic_screen.dart';
import 'package:nitrous/Test/screens/admin_screens/admin_addtopic.dart';

class UserDetailsScreen extends StatefulWidget {
  final userEmail;

  const UserDetailsScreen({Key key, this.userEmail}) : super(key: key);
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _firestore = Firestore.instance;

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
        .document("Actions")
        .collection("Actions")
        .where("userID", isEqualTo: widget.userEmail)
        .orderBy('formattedDate', descending: true)
        .limit(perpage);
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await q.getDocuments();
    _actions = querySnapshot.documents;
    lastdocument = querySnapshot.documents[querySnapshot.documents.length - 1];
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

    if (querySnapshot.documents.length < perpage) {
      _getMoreAct = false;
    }
    _actions.addAll(querySnapshot.documents);

    setState(() {
      _getMoreAct = false;
    });
  }

  // Pagination end

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

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  var userDocument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/admin_background.jpeg"),
                fit: BoxFit.fill)),
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Nitrous')
                        .document("Users")
                        .collection(widget.userEmail)
                        .document("info")
                        .snapshots(), //retorna un Stream<DocumentSnapshot>
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return new Center(child: new Text('Loading...'));
                      }

                      userDocument = snapshot.data;

                      return new Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
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
                              const EdgeInsets.only(top: 100, left: 230),
                              child: new Container(
                                width: 90.0,
                                height: 90.0,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                  NetworkImage(userDocument.data()["imgUrl"]),
                                ),
                              )),
                        ],
                      );
                    }),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,

                  children: [
                    Padding(padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AdminAddTopicScreen(
                              userData: userDocument.data,
                            ),
                          ),
                        );
                      }, // handle your image tap here
                      child: Column(
                        children: [
                          Padding(child:Text("Remove topic",style: TextStyle(fontSize: 12,color: Colors.white,fontStyle: FontStyle.italic),),
                            padding: const EdgeInsets.only(bottom: 5),),
                          Image.asset(
                            'assets/images/add.png',
                            fit: BoxFit.cover, // this is the solution for border
                            width: 50.0,
                            height: 50.0,
                          )
                        ],
                      ),
                    ),),
                    Padding(padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AdminAddTopicScreen(
                                userData: userDocument.data,
                              ),
                            ),
                          );
                        }, // handle your image tap here
                        child: Column(
                          children: [
                            Padding(child:Text("Add topic",style: TextStyle(fontSize: 12,color: Colors.white,fontStyle: FontStyle.italic),),
                              padding: const EdgeInsets.only(bottom: 5),),
                            Image.asset(
                              'assets/images/add.png',
                              fit: BoxFit.cover, // this is the solution for border
                              width: 50.0,
                              height: 50.0,
                            )
                          ],
                        ),
                      ),),

                  ],
                ),
                Padding(padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      child: Text(
                        "Name",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: 70,
                      child: Text(
                        "Action",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      width: 60,
                      child: Text(
                        "Topic",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 40,
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                        "Start",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 70,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Duration",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 50,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Date",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.only(bottom: 1),
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height * 0.3,
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
                                      : Colors.blue[200],
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
                                          TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                      Container(
                                        width: 70,
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          _actions[index].data()["title"].substring(0,1),
                                          style:
                                          TextStyle(color: Colors.white, fontSize: 10),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        width: 60,
                                        child: Text(
                                          _actions[index].data()["topic"],
                                          style:
                                          TextStyle(color: Colors.white, fontSize: 10),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        padding: EdgeInsets.symmetric(horizontal: 3),
                                        child: Text(
                                          "${_actions[index].data()["startHour"]}:${_actions[index].data()["startMin"]}",
                                          style: TextStyle(color: Colors.white),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 70,
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text(
                                          "${_actions[index].data()["startDay"]}/${_actions[index].data()["startMonth"]}/${_actions[index].data()["startYear"]}",
                                          style:
                                          TextStyle(color: Colors.white, fontSize: 10),
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
                ),              ],
            )
          ],
        ),
      ),
    );
  }
}