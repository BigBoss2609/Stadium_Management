import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:saha_owner/authentication/login_bloc.dart';
import 'package:saha_owner/authentication/sign_up.dart';
import 'package:saha_owner/component/dialog/saha_dialog_error.dart';
import 'package:saha_owner/component/dialog/saha_dialog_yes_no.dart';
import 'package:saha_owner/firebase/firebase_authentication.dart';
import 'package:saha_owner/navigator/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'init.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc loginBloc = new LoginBloc();

  FocusNode nodeOne = FocusNode();

  FocusNode nodeTwo = FocusNode();

  TextEditingController emailTextEditingController =
      new TextEditingController();

  TextEditingController passTextEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget titleSection = new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: new LinearGradient(
            colors: [Color(0xFFE54DB63), Color(0xFFE00BFA5)],
            begin: Alignment.centerRight,
            end: new Alignment(-1.0, -1.0)),
      ),
      padding: const EdgeInsets.all(35.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: new Align(
                alignment: Alignment.bottomCenter,
                child: new Text(
                  "SBD",
                  style: TextStyle(
                    fontSize: 80.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
          Align(alignment: Alignment.center),
          new Container(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: new TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
              controller: emailTextEditingController,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white54),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white54),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white54),
                ),
                hintText: "Email",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w300, color: Colors.white70),
              ),
            ),
          ),
          new Container(
            child: new TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
              controller: passTextEditingController,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white54),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white54),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white54),
                ),
                hintText: "Mật khẩu",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w300, color: Colors.white70),
              ),
            ),
          ),
          StreamBuilder<Object>(
              stream: loginBloc.emailStream,
              builder: (context, snapshot) {
                return Padding(
                  padding: EdgeInsets.all(15),
                  child: snapshot.hasData
                      ? Text(snapshot.data.toString())
                      : Container(),
                );
              }),
          new Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 55,
            width: 350,
            child: StreamBuilder<Object>(
                stream: loginBloc.loadingStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data) {
                    print(snapshot.data.toString());
                    return RaisedButton(
                      onPressed: () {},
                      color: Colors.red[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    );
                  } else
                    return RaisedButton(
                      color: Colors.red[800],
                      onPressed: () {
                        loginBloc.loginWithEmailPassword(
                            emailTextEditingController.text,
                            passTextEditingController.text, () async {
                          FirebaseAuth.instance.currentUser().then((user) {
                            FirebaseDatabase.instance
                                .reference()
                                .child('info_user')
                                .child(user.uid)
                                .once()
                                .then((data) async {
                              if (data.value != null &&
                                  data.value["Opentime"] != null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SahaNavigator(
                                              openTime: data.value["Opentime"]+.0,
                                              closeTime:
                                                  data.value["Closetime"]+.0,
                                            )));
                              } else {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Init()));
                              }
                            }).catchError((err) {
                              print(err);
                            });
                          });

                          loginBloc.setLoading(false);
                        }, (errorCode) {
                          loginBloc.setInfo(errorCode);
                          loginBloc.setLoading(false);
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400),
                      ),
                    );
                }),
          ),
          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                  padding: const EdgeInsets.all(10),
                  onPressed: () {
                    if (emailTextEditingController.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) => SahaDiaLogError(
                                title: "Lỗi!",
                                content:
                                    "Hãy nhập email có tồn tại trên hệ thống vào ô trước khi lấy lại mật khẩu",
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => SahaDiaLogYesNo(
                                title: "Lấy lại mật khẩu!",
                                content:
                                    "Chúng tôi sẽ gửi thông tin lấy lại mật khẩu về email của bạn",
                                onNo: () {},
                                onYes: () {
                                  FirebaseAuth.instance.sendPasswordResetEmail(
                                      email: emailTextEditingController.text);
                                  Navigator.pop(context);
                                },
                              ));
                    }
                  },
                  child: Text(
                    "Quên mật khẩu? ",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 40.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SahaDiaLogError(
                            title: "Xin lỗi",
                            content: "Đăng chờ tài trợ để phát triển chức năng",
                          );
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 25.0,
                      child: Image.asset(
                        'images/facebook.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SahaDiaLogError(
                            title: "Xin lỗi",
                            content: "Đăng chờ tài trợ để phát triển chức năng",
                          );
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFE54DB63),
                      radius: 25.0,
                      child: Image.asset(
                        'images/search.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          new Padding(
            padding: EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white24,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100,
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'DancingScript'),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white24,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          new Container(
            child: new FlatButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Bạn chưa có tài khoản? Hãy ",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    "đăng ký.",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(child: titleSection),
    );
  }
}
