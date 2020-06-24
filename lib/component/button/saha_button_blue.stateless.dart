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
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(20)
      ),
      child: Container(
        decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [Color(0xFFE54DB63), Color(0xFFE00BFA5)],
                begin: Alignment.centerRight,
                end: new Alignment(-1, -1)),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        height: 45,
        width: 150,
        child: Center(
          child: this.child,
        ),
      ),
      onPressed: onPressed,
    );
  }


}
