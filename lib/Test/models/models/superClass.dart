import 'topic.dart';

class SuperClass {
  String title;

  int num;
  List<Topic> topics = [];
  SuperClass({this.title, this.topics, this.num});

  editTitle(title) => this.title = title;
}
