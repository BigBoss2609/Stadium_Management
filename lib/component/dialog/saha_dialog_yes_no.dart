import 'package:flutter/material.dart';

class SahaDiaLogYesNo extends StatelessWidget{

  final Function onYes;
  final Function onNo;
  final String title;
  final String content;

  SahaDiaLogYesNo({this.onYes, this.onNo, this.title, this.content});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: new Text(title),
      content: new Text(content),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Yes"),
          onPressed: () {
            onYes();
          },
        ),
        new FlatButton(
          child: new Text("No"),
          onPressed: () {
            onNo();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}