import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Item(value: 10),
            Item(value: 0),
            Item(value: 16),
            Item(value: 70),
            Item(value: 55),
            Item(value: 100),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  width: 55,
                  child: Text(
                    "Work ethics",
                    style: TextStyle(fontSize: 10),
                  )),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  width: 55,
                  child: Text(
                    "Work ethics",
                    style: TextStyle(fontSize: 10),
                  )),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  width: 55,
                  child: Text(
                    "Work ethics",
                    style: TextStyle(fontSize: 10),
                  )),
              Container(
                  padding: EdgeInsets.only(right: 6, left: 6),
                  width: 55,
                  child: Text(
                    "Work ethics",
                    style: TextStyle(fontSize: 10),
                  )),
              Container(
                  padding: EdgeInsets.only(right: 6, left: 6),
                  width: 55,
                  child: Text(
                    "Work ethics",
                    style: TextStyle(fontSize: 10),
                  )),
              Container(
                  width: 40,
                  child: Text(
                    "Work ethics",
                    style: TextStyle(fontSize: 10),
                  )),
            ],
          ),
        )
      ],
    );
  }
}

class Item extends StatelessWidget {
  final int value;

  const Item({Key key, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(150 * ((value - (value % 10)) / 100));
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 150,
          width: 6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          height: 150 * ((value - (value % 10)) / 100),
          width: 6,
          decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ],
    );
  }
}