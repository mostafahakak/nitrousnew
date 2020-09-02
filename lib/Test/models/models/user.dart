import './solo_action.dart';

class User {
  final String email;
  final String jobTitle;
  final String userName;
  String imgUrl;
  List<SoloAction> soloActions = [];
  int class_1;
  int class_2;
  int class_3;
  int class_4;
  int class_5;
  int class_6;

  User({
    this.imgUrl,
    this.email,
    this.jobTitle,
    this.userName,
    this.soloActions,
    this.class_1,
    this.class_2,
    this.class_3,
    this.class_4,
    this.class_5,
    this.class_6,
  });
}
