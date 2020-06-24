import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:saha_owner/authentication/login.dart';
import 'package:saha_owner/component/button/saha_back_button.dart';
import 'package:saha_owner/component/button/saha_button_blue.stateless.dart';
import 'package:saha_owner/firebase/firebase_authentication.dart';
import 'AddInfo.dart';

class Legal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDFE9F7),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  gradient: new LinearGradient(
                      colors: [Color(0xFFE54DB63), Color(0xFFE00BFA5)],
                      begin: Alignment.centerRight,
                      end: new Alignment(0.8, -1)),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
              ),
              Container(
                padding: EdgeInsets.all(80),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Thông tin về app",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SahaBackButton(),
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Thành viên : Minh - Quân - Thịnh - Duyệt ",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Hotline hỗ trợ : 0868025879 ",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Email : daigiaau98@gmail.com ",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: Card(
                    child: ListTile(
                      title: Text("Phiên bản hiện tại : 1.0.1"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Điều khoản sử dụng",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Pháp lí ",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Giới thiệu ",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Image.asset(
                    'images/logo.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Info extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Inform();
}

class Inform extends State<Info> {
  String name = "";
  String address = "";
  String phone = "";
  String email = "";
  bool isLoading = true;
  String downloadUrl = "";
  bool isLoadingImage = true;
  StorageReference firebaseStorageRef;

  void downloadImage() {
    setState(() {
      isLoadingImage = true;
      print(downloadUrl);
    });
    FireBaseAuth().auth.currentUser().then((user) async {
      firebaseStorageRef =
          FirebaseStorage.instance.ref().child(user.uid + ".jpg");
      String downpicture;
      try {
        downpicture = await firebaseStorageRef.getDownloadURL();
      } catch (err) {
        setState(() {
          isLoading = false;
        });
      }

      setState(() {
        downloadUrl = downpicture ?? "";
        isLoadingImage = false;
        print(downloadUrl);
      });
    });
  }

  @override
  void initState() {
    loadInfo();
  }

  void loadInfo() {
    downloadImage();
    // ignore: unnecessary_statements
    FirebaseAuth.instance.currentUser().then((data) {
      FirebaseDatabase.instance
          .reference()
          .child('info_user')
          .child(data.uid)
          .once()
          .then((data) {
        setState(() {
          name = data.value["Names"];
          address = data.value["Adress"];
          phone = data.value["Phones"];
          email = data.value["Emails"];
          isLoading = false;
        });
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDFE9F7),
      body: Column(
        children: <Widget>[
          Stack(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                gradient: new LinearGradient(
                    colors: [Color(0xFFE54DB63), Color(0xFFE00BFA5)],
                    begin: Alignment.centerRight,
                    end: new Alignment(0.8, -1)),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 45),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                    ),
                    Text(
                      "",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.green[400],
                  child: ClipOval(
                    child: SizedBox(
                        width: 180,
                        height: 180,
                        child: isLoadingImage
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.redAccent,
                              )
                            : downloadUrl == ""
                                ? Image.asset(
                                    'images/empty-avatar-700x480.png',
                                    fit: BoxFit.cover,
                                  )
                                : Image(
                          fit: BoxFit.cover,
                                    image: NetworkImage(downloadUrl),
                                  )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 45),
                    ),
                    Text(
                      name ?? " ",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700]),
                    ),
                  ],
                ),
              ]),
            )
          ]),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: <Widget>[
                      Card(
                        child: ListTile(
                          title: Text(
                            phone == null ? "" : phone,
                          ),
                          subtitle: Text("Số điện thoại"),
                          leading: IconButton(
                            icon: Icon(
                              Icons.phone,
                              color: Colors.green[800],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(
                            email == null ? "" : email,
                          ),
                          subtitle: Text(
                            "E-mail",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon: Icon(Icons.email, color: Colors.green[800]),
                              onPressed: () {}),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(
                            address == null ? "" : address,
                          ),
                          subtitle: Text(
                            "Địa chỉ",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon: Icon(Icons.work, color: Colors.green[800]),
                              onPressed: () {}),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Card(
                            child: ListTile(
                                title: Text(
                                  "Thông tin về App",
                                ),
                                subtitle: Text(
                                  "SahaTeam",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                leading: Icon(
                                  Icons.error_outline,
                                  color: Colors.green[800],
                                )),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Legal()));
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                      ),
                      Container(
                        child: SahaButton(
                          child: Text(
                            "Đăng xuất",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () {
                            FireBaseAuth().auth.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Addinfo(
                      name: name,
                      phone: phone,
                      address: address,
                      imageAvt: downloadUrl,
                      onChange: (reset) {
                        setState(() {
                          name = reset;
                          address = reset;
                          phone = reset;
                        });
                      }))).then((value) {
            loadInfo();
          });
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
