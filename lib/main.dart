import 'package:flutter/material.dart';
import 'package:saha_owner/splash/splash.dart';

import 'authentication/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saha',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryTextTheme: TextTheme(
          display1: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w900
          )
        ),
        primarySwatch:  Colors.green,
          primaryColor: Colors.green,
      ),
      home: SplashScreen(),
    );
  }
}

