import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitrous/Test/screens/admin_screens/user_details_screen.dart';

class UsersScreen extends StatelessWidget {
  final _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection("Nitrous")
              .document("Users")
              .collection("Users")
              .snapshots(),
          builder: (ctx, snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              );
            }
            var docs = snap.data.documents;
            return GridView.builder(
                itemCount: docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (ctx, index) {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: _firestore
                          .collection('Nitrous')
                          .document("Users")
                          .collection(docs[index].data()["email"])
                          .document("info")
                          .snapshots(),
                      builder: (ctx, snap) {
                        if (!snap.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          );
                        }
                        var doc = snap.data;
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UserDetailsScreen(
                                  userEmail: doc.data()["email"],
                                ),
                              ),
                            );
                            print(doc.data()["email"]);
                          },
                          child: Column(
                            children: [
                              doc.data()["imgUrl"] == ""
                                  ? CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 40,
                              )
                                  : CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                NetworkImage(doc.data()["imgUrl"]),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  doc.data()["userName"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Text(
                                doc.data()["jobTitle"],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          ),
                        );
                      });
                });
          }),
    );
  }
}