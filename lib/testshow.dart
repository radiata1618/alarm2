import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TestshowWidget extends StatefulWidget {
  final alarmId;


  TestshowWidget({this.alarmId});

  @override
  _TestshowWidgetState createState() => _TestshowWidgetState();
}


class _TestshowWidgetState extends State<TestshowWidget> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
            child:Text("1"))
    );
  }
}
