import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLogScreen extends StatefulWidget {
  @override
  _ActivityLogScreenState createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 60,
              padding: EdgeInsets.symmetric(horizontal: 8),
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
              width: 70,
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
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Nitrous')
              .doc("Actions")
              .collection("Actions")
              .orderBy('formattedDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            var docs = snapshot.data.documents;

            return Container(
              height: 450,
              child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      color: !(index % 2 == 0)
                          ? Colors.transparent
                          : Colors.blue[200],
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              docs[index]
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
                              docs[index].data()["title"],
                              style:
                              TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            width: 70,
                            child: Text(
                              docs[index].data()["topic"],
                              style:
                              TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                          Container(
                            width: 50,
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              "${docs[index].data()["startHour"]}:${docs[index].data()["startMin"]}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              (docs[index].data()["status"] == "Done")
                                  ? "${docs[index].data()["duration"]}"
                                  : "--",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 70,
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "${docs[index].data()["startDay"]}/${docs[index].data()["startMonth"]}/${docs[index].data()["startYear"]}",
                              style:
                              TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            );
          },
        ),
      ],
    );
  }
}