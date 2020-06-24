import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:saha_owner/authentication/init.dart';
import 'package:saha_owner/authentication/login.dart';
import 'package:saha_owner/navigator/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user == null) {
        noLogged();
      }
      FirebaseDatabase.instance
          .reference()
          .child('info_user')
          .child(user.uid)
          .once()
          .then((data) async {
            if(data.value != null && data.value["Opentime"] != null) {

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('open_time',data.value["Opentime"] );
              prefs.setInt('close_time',data.value["Closetime"] );


              logged();
            } else {

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Init()));

            }
      }).catchError((err) {
        noLogged();
      });
    });
  }

  logged() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var openTime = await prefs.getInt('open_time');
    var closeTime = await prefs.getInt('close_time');


    new Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SahaNavigator(openTime: openTime+.0, closeTime: closeTime+.0)));
    });
  }

  noLogged() async {
    new Timer(Duration(seconds: 1), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [Color(0xFFE54DB63), Color(0xFFE00BFA5)],
                begin: Alignment.centerRight,
                end: new Alignment(-1.0, -1.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Saha",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Quản lý sân bóng chuyên nghiệp",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
