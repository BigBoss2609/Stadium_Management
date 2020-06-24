import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saha_owner/authentication/sign_up_bloc.dart';
import 'package:saha_owner/component/button/saha_back_button.dart';
import 'package:saha_owner/component/button/saha_button_green.stateless.dart';
import 'package:saha_owner/component/text_field/saha_text_field.dart';
import 'package:saha_owner/firebase/firebase_authentication.dart';
import 'package:saha_owner/navigator/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Init extends StatefulWidget {
  @override
  _InitState createState() => _InitState();
}

class _InitState extends State<Init> {
  TextEditingController addressController = new TextEditingController();

  TextEditingController opentimeController = new TextEditingController();

  TextEditingController closetimeController = new TextEditingController();

  int timeStart;

  int timeStop;

  SignUpBloc signUpBloc = new SignUpBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 23, left: 0, right: 0),
            child: Container(
              color: Colors.deepOrange,
              height: 200,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 72,
                      bottom: 70,
                    ),
                    child: Text(
                      "Thông tin địa điểm",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
                top: 150, left: 10, right: 10, bottom: 150),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40)),
                border: Border.all(color: Colors.grey),
              ),
              child: ListView(
                children: <Widget>[
                  Container(
                    child: SahaTextField(
                      controller: addressController,
                      labelText: "Địa chỉ",
                      icon: Icon(
                        Icons.place,
                        color: Colors.green,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        buildTimeStart(),
                        buildTimeStop(),
                      ],
                    ),
                  ),


                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SahaButton(
                        onPressed: () {
                          FireBaseAuth().auth.currentUser().then((user) {
                            FirebaseDatabase.instance
                                .reference()
                                .child('info_user')
                                .child(user.uid)
                                .once()
                                .then((data) {
                              var map = data.value;

                              if(map == null) {
                                map = new Map<String,dynamic>();
                              }
                              map["AdressYard"] = addressController.text;
                              map["Opentime"] = timeStart;
                              map["Closetime"] = timeStop;
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('info_user')
                                  .child(user.uid)
                                  .set(map).then((pp ) async{

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setInt('open_time',timeStart);
                                await prefs.setInt('close_time',timeStop);

                                    Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context)=>SahaNavigator(openTime: timeStart+.0, closeTime: timeStop+.0))
                                    );
                              });
                            });
                          });
                        },
                        child: Text(
                          "DONE",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTimeStart() {
    var listItem = new List<DropdownMenuItem<int>>();
    for(int hour = 1; hour < 12; hour+=1) {
      listItem.add(
        DropdownMenuItem(
          child: new Text(hour.toString() +"h"),
          value: hour,
        )
      );
    }
    return DropdownButton(
      hint: Text("Giờ mở cửa"),
      value: timeStart,
      items: listItem,
      onChanged: (int value) {
                setState(() {
                  timeStart = value;
                });
      },
    );
  }

  Widget buildTimeStop() {
    var listItem = new List<DropdownMenuItem<int>>();
    for(int hour = 13; hour < 24; hour+=1) {
      listItem.add(
          DropdownMenuItem(
            child: new Text(hour.toString() +"h"),
            value: hour,
          )
      );
    }
    return DropdownButton(
      hint: Text("Giờ đóng cửa"),
      value: timeStop,
      items: listItem,
      onChanged: (int value) {
                setState(() {
                  timeStop = value;
                });
      },
    );
  }
}
