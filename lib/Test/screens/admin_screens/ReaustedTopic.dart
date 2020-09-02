import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequesteTopic extends StatefulWidget {

  @override
  _RequesteTopic createState() => _RequesteTopic();
}

class _RequesteTopic extends State<RequesteTopic> {
  final _firestore = Firestore.instance;
  final ClassController = TextEditingController();
  final factorController = TextEditingController();
  final TypeCont = TextEditingController();
  String type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/admin_background.jpeg"),
                fit: BoxFit.fill)),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Nitrous')
              .document("Admin")
              .collection("RequestedTopics")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            var docs = snapshot.data.documents;

            return Container(
              height: 450,
              child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (ctx, index) {
                    return Padding(padding: const EdgeInsets.only(top: 10),
                    child: Card(

                      child: Column(
                        children: [
                          Padding(padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              docs[index]
                                  .data()["username"],
                              style:
                              TextStyle(color: Colors.black, fontSize: 12),
                            ),),
                          Padding(padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              docs[index]
                                  .data()["why"],
                              style:
                              TextStyle(color: Colors.black, fontSize: 12),
                            ),),
                          Padding(padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              docs[index]
                                  .data()["topicName"],
                              style:
                              TextStyle(color: Colors.black, fontSize: 12),
                            ),),

                          Padding(padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () async{
                                      String x =  docs[index].data()["id"];
                                      await _firestore
                                          .collection('Nitrous')
                                          .document("Admin")
                                          .collection("RequestedTopics").document(x).delete();
                                    }, // handle your image tap here
                                    child: Column(
                                      children: [
                                        Padding(child:Text("Delete",style: TextStyle(fontSize: 12,color: Colors.black,fontStyle: FontStyle.italic),),
                                          padding: const EdgeInsets.only(bottom: 5),),
                                        Image.asset(
                                          'assets/images/back.png',
                                          fit: BoxFit.cover, // this is the solution for border
                                          width: 50.0,
                                          height: 50.0,
                                        )
                                      ],
                                    ),
                                  ),

                                ),
                                Container(
                                  width: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {

                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Container(
                                            width: 200,
                                            height: 300,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [

                                                DropdownButton<String>(

                                                    hint: new Text('Pick'),
                                                    value: type,
                                                    onChanged: (String values) {
                                                      setState(() {
                                                          type = values;
                                                          print(type);
                                                                    });
                                                                                },
                                                  items: [
                                                      DropdownMenuItem(
                                                        child: Text("Learn"),
                                                        value: "Learn",
                                                      ),
                                                      DropdownMenuItem(
                                                        child: Text("Implement"),
                                                        value: "Implement",
                                                      ),
                                                      DropdownMenuItem(
                                                        child: Text("Tech"),
                                                        value: "Tech",
                                                      ),
                                                    ],
                                                    ),

                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Class",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                                  padding: const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black26,
                                                            offset: Offset(0, 0),
                                                            blurRadius: 3)
                                                      ]),
                                                  child: TextFormField(
                                                    keyboardType: TextInputType.phone,
                                                    controller: ClassController,
                                                    decoration: InputDecoration.collapsed(
                                                        hintText: "class number",
                                                        hintStyle: TextStyle(color: Colors.grey[400])),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Factor",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                                  padding: const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black26,
                                                            offset: Offset(0, 0),
                                                            blurRadius: 3)
                                                      ]),
                                                  child: TextFormField(
                                                    keyboardType: TextInputType.phone,
                                                    controller: factorController,
                                                    decoration: InputDecoration.collapsed(
                                                        hintText: "Factor number",
                                                        hintStyle: TextStyle(color: Colors.grey[400])),
                                                  ),
                                                ),
                                                FlatButton(
                                                    color: Colors.blue,
                                                    onPressed: () async {
                                                      DocumentReference documentReference = Firestore.instance
                                                          .collection('Nitrous')
                                                          .document("Users")
                                                          .collection(docs[index]
                                                          .data()["email"]
                                                          .toString())
                                                          .document("classes")
                                                          .collection(type).document();

                                                      documentReference.setData({
                                                        "topicName":docs[index].data()["topicName"].toString(),
                                                        "factor":int.parse(factorController.text),
                                                        "classnumber":int.parse(ClassController.text),
                                                      });

                                                      String x =  docs[index].data()["id"];
                                                      await _firestore
                                                          .collection('Nitrous')
                                                          .document("Admin")
                                                          .collection("RequestedTopics").document(x).delete();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Ok",
                                                      style: TextStyle(color: Colors.white),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );

                                    }, // handle your image tap here
                                    child: Column(
                                      children: [
                                        Padding(child:Text("Add topic",style: TextStyle(fontSize: 12,color: Colors.black,fontStyle: FontStyle.italic),),
                                          padding: const EdgeInsets.only(bottom: 5),),
                                        Image.asset(
                                          'assets/images/add.png',
                                          fit: BoxFit.cover, // this is the solution for border
                                          width: 50.0,
                                          height: 50.0,
                                        )
                                      ],
                                    ),
                                  ),

                                ),

                              ],
                            ),),

                        ],
                      ),
                    ),);
                  }),
            );
          },
        ),
      ),
    );
  }
}