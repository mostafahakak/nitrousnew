import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAddTopicScreen extends StatefulWidget {
  final userData;

  const AdminAddTopicScreen({Key key, this.userData}) : super(key: key);
  @override
  _AddTopicScreenState createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AdminAddTopicScreen> {
  String classNum ;
  final topicController = TextEditingController();
  final factorController = TextEditingController();
  final classController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    print(widget.userData["email"]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            Image.asset("assets/images/background.png"),
            Container(
              margin: EdgeInsets.only(top: 60),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 0),
                        blurRadius: 3)
                  ]),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Add topic",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  widget.userData["imgUrl"] == ""
                      ? Container(
                    padding: EdgeInsets.all(7),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 0),
                              blurRadius: 3)
                        ]),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          shape: BoxShape.circle),
                    ),
                  )
                      : CircleAvatar(
                    radius: 40,
                    backgroundImage:
                    NetworkImage(widget.userData["imgUrl"]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.userData["userName"],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Class",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButton(
                      value: classNum,
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
                          child: Text("Teach"),
                          value: "Teach",
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          classNum = value;
                        });
                      }),
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
                      controller: classController,
                      decoration: InputDecoration.collapsed(
                          hintText: "class number",
                          hintStyle: TextStyle(color: Colors.grey[400])),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Topic",
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
                      controller: topicController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Enter topic name",
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
                          hintText: "Enter factor value",
                          hintStyle: TextStyle(color: Colors.grey[400])),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    }, // handle your image tap here
                    child: Image.asset(
                      'assets/images/back.png',
                      fit: BoxFit.cover, // this is the solution for border
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () async {

                      bool valid = true;
                      if (classNum == null ||
                          topicController.text == null ||
                          topicController.text == "" ||
                          factorController.text == null ||
                          factorController.text == "") {
                        valid = false;
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Container(
                              width: 200,
                              height: 100,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Error",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "There is missing value",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  FlatButton(
                                      color: Colors.blue,
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      setState(() {
                        loading = true;
                      });
                      if (valid) {
                        try {
                          await Firestore.instance
                              .collection('Nitrous')
                              .document("Users")
                              .collection(widget.userData["email"])
                              .document("classes")
                              .collection(classNum)
                              .add({
                            "classnumber": int.parse(classController.text),
                            "factor": int.parse(factorController.text),
                            "topicName": topicController.text,
                          });
                          classController.clear();
                          topicController.clear();
                          factorController.clear();
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Container(
                                width: 200,
                                height: 170,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Error",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Container(
                                      width: 150,
                                      child: Text(
                                        e.toString(),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    FlatButton(
                                        color: Colors.blue,
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }

                      setState(() {
                        loading = false;
                      });
                      print(classController);
                      print(topicController.text);
                      print(factorController.text);
                    }, // handle your image tap here
                    child: Image.asset(
                      'assets/images/submit.png',
                      fit: BoxFit.cover, // this is the solution for border
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* switch (classNum) {
                                                                                  case 1:
                                                                                    topic = "Internal commmunication";
                                                                                    break;
                                                                                  case 2:
                                                                                    topic = "External commmunication";
                                                                                    break;
                                                                                  case 3:
                                                                                    topic = "Learn";
                                                                                    break;
                                                                                  case 4:
                                                                                    topic = "Tech";
                                                                                    break;
                                                                                  case 5:
                                                                                    topic = "Relative";
                                                                                    break;
                                                                                  case 6:
                                                                                    topic = "Teach";
                                                                                    break;
                                                                                } */