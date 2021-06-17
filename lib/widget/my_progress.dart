import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyProgress extends StatefulWidget {
  String type;

  MyProgress({this.type = "circular"});

  @override
  _MyProgressState createState() => new _MyProgressState();
}

class _MyProgressState extends State<MyProgress> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == "linear")
      return LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor));
    else
      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
  }
}
