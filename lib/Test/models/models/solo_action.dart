import 'package:nitrous/Test/models/models/superClass.dart';
import 'package:nitrous/Test/models/models/topic.dart';

class SoloAction {
  final String id;
  String title;
  Topic topic;
  SuperClass superClass;
  final DateTime date;
  final String formatedDate;
  final int day;
  final int month;
  final int year;
  int duration;
  double value;
  final int startHour;
  final int startMin;
  final int endHour;
  final int endMin;
/*   int breakDuration;
  String breakStartTime;
  String breakEndTime; */
  final String userID;
  final double factor;
  String status;

  SoloAction({
    this.id,
    this.superClass,
    this.topic,
    this.factor,
    this.title,
    this.date,
    this.formatedDate,
    this.duration,
    this.value,
/*     this.breakDuration,
    this.breakStartTime,
    this.breakEndTime, */
    this.userID,
    this.startHour,
    this.startMin,
    this.endHour,
    this.endMin,
    this.day,
    this.month,
    this.year,
    this.status,
  });
}
