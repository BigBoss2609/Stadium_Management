import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

// ignore: must_be_immutable
class SahaButton extends StatelessWidget {
  VoidCallback onPressed;
  Widget child;
  SahaButton ({
    this.onPressed,this.child
});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RaisedButton(
      color: Colors.red[800],
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(40.0)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25))
        ),
        height: 50,
        width: 150,
        child: Center(
          child: this.child,
        ),
      ),
      onPressed: onPressed,
    );
  }


}
