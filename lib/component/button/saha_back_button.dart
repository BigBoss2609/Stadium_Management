import 'package:flutter/material.dart';

class SahaBackButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(1),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_left,color: Colors.green,size: 40,),
          ),
          onPressed: (){
              Navigator.pop(context);
          },

    );
  }
}