import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TestshowWidget extends StatefulWidget {


  TestshowWidget({Key key}) : super(key: key);

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
