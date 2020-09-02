import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nitrous/Test/models/models/superClass.dart';
import 'package:nitrous/Test/models/models/topic.dart';

import '../models/models/solo_action.dart';
import '../models/models/user.dart';

class Data {
  static User user = User(email: "test1@test.com", soloActions: []);
  SoloAction action;
  final _firestore = Firestore.instance;
  final _storage = FirebaseStorage.instance;
  List<SuperClass> classes = [
    SuperClass(title: "Internal Communication", num: 1),
    SuperClass(title: "External Communication", num: 2),
    SuperClass(title: "Learn", num: 3),
    SuperClass(title: "Tech", num: 4),
    SuperClass(title: "Relative", num: 5),
    SuperClass(title: "Teach", num: 6),
  ];

  getUserInfo(email) async {
    var document = await _firestore.collection("Users").document(email).get();
    setUser(User(
      email: document.data()["email"],
      imgUrl: document.data()["imgUrl"],
      userName: document.data()["userName"],
      jobTitle: document.data()["jobTitle"],
    ));
  }

  setUser(user) {
    user = user;
  }


  Future<void> uploadPic() async {
    //Get the file from the image picker and store it
    final file = ImagePicker();
    PickedFile pickedImage = await file.getImage(source: ImageSource.gallery);
    File image = File(pickedImage.path);

    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child("images/${user.email}");

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(image);
    if (uploadTask.isInProgress) {
      print("loading");
    } else if (uploadTask.isComplete) {
      user.imgUrl = (await reference.getDownloadURL()).toString();
    }
  }

  void startSoloAction({topic, superClass, title}) {
    var date = DateTime.now();
    var formatedDate = DateFormat.yMMMEd().format(date);
    DocumentReference documentReference =
        _firestore.collection("Actions").document();
    action = SoloAction(
        id: documentReference.documentID,
        topic: Topic(title: topic, classNum: superClass),
        superClass: classes[superClass],
        title: title,
        startHour: date.hour,
        startMin: date.minute,
        day: date.day,
        month: date.month,
        year: date.year,
        date: date,
        formatedDate: formatedDate,
        factor: 1,
        status: "Ongoing",
        userID: user.email);

    documentReference.setData({
      "id": documentReference.documentID,
      "topic": action.topic.title,
      "classNum": action.topic.classNum,
      "title": action.title,
      "startHour": action.startHour,
      "startMin": action.startMin,
      "day": action.day,
      "month": action.month,
      "year": action.year,
      "endTime": "${date.hour} : ${date.minute}",
      "duration": action.duration,
/*       "breakStartTime": action.breakStartTime,
      "breakEndTime": action.breakEndTime,
      "breakDuration": action.breakDuration, */
      "formatedDate": action.formatedDate,
      "date": action.date,
      "status": "Ongoing",
      "userID": user.email
    });

    user.soloActions.add(action);
  }

  void endSoloAction() {
    // TO DO: add function to calculate difficulty
    var date = DateTime.now();
    var duration =
        ((date.hour - action.startHour) * 60) + (date.minute - action.startMin);
    DocumentReference documentReference = _firestore
        .collection("Actions")
        .document(user.email)
        .collection(user.email)
        .document(action.id);
    documentReference.updateData({
      "duration": duration,
      "endHour": date.hour,
      "endMin": date.minute,
      "status": "Done"
    });
    action = null;
  }

  /* void startBreak() {
    var date = DateTime.now();
    DocumentReference documentReference = _firestore
        .collection("Actions")
        .document(user.email)
        .collection(user.email)
        .document(action.id);
    documentReference
        .updateData({"breakStartTime": "${date.hour} : ${date.minute}"});
  }

  void endBreak() {
    DocumentReference documentReference = _firestore
        .collection("Actions")
        .document(user.email)
        .collection(user.email)
        .document(action.id);
    var date = DateTime.now();
    var start = action.startTime.split(":");
    var duration = ((date.hour - int.parse(start[0])) * 60) +
        (date.minute - int.parse(start[1]));
    documentReference.updateData({
      "breakEndTime": "${date.hour} : ${date.minute}",
      "breakDuration": duration
    });
  } */
}
