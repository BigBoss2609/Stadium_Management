import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SahaDialogLoading extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content:  Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator()
          ],
        ),
      )
    );
  }
}