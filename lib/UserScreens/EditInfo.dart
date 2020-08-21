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


class EditInfo extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<EditInfo> {



  final _firestore = Firestore.instance;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _counter;
  File _image;

  final _usernameController = TextEditingController();
  final _positionController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _monthJController = TextEditingController();
  final _yearJController = TextEditingController();


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





  @override
  void initState() {
    super.initState();

    _counter = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('username'));
    }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                              _usernameController.text = userDocument["name"];
                              _positionController.text = userDocument["title"];
                              _dayController.text = userDocument["Bday"].toString();
                              _monthController.text = userDocument["Bmonth"].toString();
                              _yearController.text = userDocument["Byear"].toString();
                              _monthJController.text = userDocument["Jmonth"].toString();
                              _yearJController.text = userDocument["Jyear"].toString();


                              return new Padding(
                                padding: const EdgeInsets.only(top: 20,right: 20,left: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white24)),
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text("Edit profile",style: TextStyle(fontSize: 22),),),
                                    Padding(padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        width: 90.0,
                                        height: 90.0,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(userDocument["image"]),
                                        ),
                                      ),),
                                    Padding(padding: const EdgeInsets.only(top: 10),
                                      child: Text("WHAT IS YOUR NAME?",style: TextStyle(fontSize: 18),),),
                                    Padding(padding: const EdgeInsets.only(top: 10,left: 30,right: 30),
                                      child: SizedBox(height: 50,
                                        child: TextFormField(
                                          controller: _usernameController,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:  Colors.black,
                                          ),
                                          cursorColor:Colors.black,
                                          keyboardType: TextInputType.phone,
                                          decoration: new InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black, width: 5.0),
                                            ),
                                            labelText: "Enter name",
                                            labelStyle: TextStyle(
                                                color: Colors.black
                                            ),
                                            enabledBorder:  const OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(
                                                const Radius.circular(20.0),
                                              ),
                                              borderSide: const BorderSide(color: Colors.black),
                                            ),  //fillColor: Colors.green
                                          ),
                                        ),),),

                                    Padding(padding: const EdgeInsets.only(top: 10),
                                      child: Text("WHAT ARE YOU DOING?",style: TextStyle(fontSize: 12),),),
                                    Padding(padding: const EdgeInsets.only(top: 10,left: 30,right: 30),
                                      child: SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          controller: _positionController,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:  Colors.black,
                                          ),
                                          cursorColor:Colors.black,
                                          keyboardType: TextInputType.phone,
                                          decoration: new InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black, width: 5.0),
                                            ),
                                            labelText: "Enter position",
                                            labelStyle: TextStyle(
                                                color: Colors.black
                                            ),
                                            enabledBorder:  const OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(
                                                const Radius.circular(20.0),
                                              ),
                                              borderSide: const BorderSide(color: Colors.black),
                                            ),  //fillColor: Colors.green
                                          ),
                                        ),
                                      ),),
                                    Padding(padding: const EdgeInsets.only(top: 20),
                                      child: Text("YOU ARE LIVING ON EARTH SINCE?",style: TextStyle(fontSize: 12),),),
                                    Padding(padding: const EdgeInsets.only(top: 10,left: 30,right: 20),
                                      child: Row(
                                        children: [
                                          Padding(padding: const EdgeInsets.only(top: 10),
                                            child: SizedBox(
                                              height: 40,
                                              width: 60,
                                              child: TextFormField(
                                                controller: _dayController,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:  Colors.black,
                                                ),
                                                cursorColor:Colors.black,
                                                keyboardType: TextInputType.phone,
                                                decoration: new InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                                                  ),
                                                  labelText: "Day",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black
                                                  ),
                                                  enabledBorder:  const OutlineInputBorder(
                                                    borderRadius: const BorderRadius.all(
                                                      const Radius.circular(20.0),
                                                    ),
                                                    borderSide: const BorderSide(color: Colors.black),
                                                  ),  //fillColor: Colors.green
                                                ),
                                              ),
                                            ),),
                                          Padding(padding: const EdgeInsets.only(top: 10,left: 20),
                                            child: SizedBox(
                                              height: 40,
                                              width: 60,
                                              child: TextFormField(
                                                controller: _monthController,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:  Colors.black,
                                                ),
                                                cursorColor:Colors.black,
                                                keyboardType: TextInputType.phone,
                                                decoration: new InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                                                  ),
                                                  labelText: "MM",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black
                                                  ),
                                                  enabledBorder:  const OutlineInputBorder(
                                                    borderRadius: const BorderRadius.all(
                                                      const Radius.circular(20.0),
                                                    ),
                                                    borderSide: const BorderSide(color: Colors.black),
                                                  ),  //fillColor: Colors.green
                                                ),
                                              ),
                                            ),),
                                          Padding(padding: const EdgeInsets.only(top: 10,left: 20),
                                            child: SizedBox(
                                              height: 40,
                                              width: 60,
                                              child: TextFormField(
                                                controller: _yearController,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:  Colors.black,
                                                ),
                                                cursorColor:Colors.black,
                                                keyboardType: TextInputType.phone,
                                                decoration: new InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                                                  ),
                                                  labelText: "YY",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black
                                                  ),
                                                  enabledBorder:  const OutlineInputBorder(
                                                    borderRadius: const BorderRadius.all(
                                                      const Radius.circular(20.0),
                                                    ),
                                                    borderSide: const BorderSide(color: Colors.black),
                                                  ),  //fillColor: Colors.green
                                                ),
                                              ),
                                            ),),

                                        ],
                                      ),),

                                    Padding(padding: const EdgeInsets.only(top: 10),
                                      child: Text("YOU JOINED US SINCE?",style: TextStyle(fontSize: 18),),),
                                    Padding(padding: const EdgeInsets.only(top: 10,left: 30,right: 30),
                                      child: Row(
                                        children: [
                                          Padding(padding: const EdgeInsets.only(top: 10,left: 20),
                                            child: SizedBox(
                                              height: 40,
                                              width: 60,
                                              child: TextFormField(
                                                controller: _monthJController,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:  Colors.black,
                                                ),
                                                cursorColor:Colors.black,
                                                keyboardType: TextInputType.phone,
                                                decoration: new InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                                                  ),
                                                  labelText: "MM",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black
                                                  ),
                                                  enabledBorder:  const OutlineInputBorder(
                                                    borderRadius: const BorderRadius.all(
                                                      const Radius.circular(20.0),
                                                    ),
                                                    borderSide: const BorderSide(color: Colors.black),
                                                  ),  //fillColor: Colors.green
                                                ),
                                              ),
                                            ),),
                                          Padding(padding: const EdgeInsets.only(top: 10,left: 100),
                                            child: SizedBox(
                                              height: 40,
                                              width: 60,
                                              child: TextFormField(
                                                controller: _yearJController,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:  Colors.black,
                                                ),
                                                cursorColor:Colors.black,
                                                keyboardType: TextInputType.phone,
                                                decoration: new InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                                                  ),
                                                  labelText: "YY",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black
                                                  ),
                                                  enabledBorder:  const OutlineInputBorder(
                                                    borderRadius: const BorderRadius.all(
                                                      const Radius.circular(20.0),
                                                    ),
                                                    borderSide: const BorderSide(color: Colors.black),
                                                  ),  //fillColor: Colors.green
                                                ),
                                              ),
                                            ),),

                                        ],
                                      ),),

                                    Padding(padding: const EdgeInsets.only(top: 20),
                                      child: FlatButton(
                                        onPressed:  (){

                                        },
                                        child: Text('Submit', style: TextStyle(
                                            color: Colors.black
                                        )
                                        ),
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(side: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid
                                        ), borderRadius: BorderRadius.circular(50)),
                                      ),),


                                  ],),
                                ),
                              );
                            }
                        ),
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


    SharedPreferences pre = await SharedPreferences.getInstance();
    String name;


    name = pre.getString('username');
    print(name);



    DocumentReference documentReference = _firestore
        .collection("Nitrous")
        .document("Users")
        .collection(name)
        .document("info");
    documentReference.updateData({

      "name": _usernameController.text,
      "title": _positionController.text,
      "dateofbirth": _dayController.text+_monthController.text+_yearController.text,
      "startdate": _monthJController.text+_yearJController.text,
    });

    Navigator.pop(context);


  }


}

