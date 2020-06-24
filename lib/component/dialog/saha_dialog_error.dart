import 'package:flutter/material.dart';

class SahaDiaLogError extends StatelessWidget{

  final String title;
  final String content;

  SahaDiaLogError({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: new Text(title),
      content: new Text(content, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w300, fontSize: 17)),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Yes"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

}