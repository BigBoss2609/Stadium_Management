import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saha_owner/component/text_field/saha_text_field.dart';
import 'package:saha_owner/firebase/firebase_authentication.dart';
import 'package:saha_owner/navigator/info/info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class Addinfo extends StatefulWidget {
  final Function(String) onChange;
  final String phone, name, address, imageAvt;

  const Addinfo(
      {Key key,
      this.onChange,
      this.phone,
      this.name,
      this.address,
      this.imageAvt})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    print(this.name);
    return Addinform(
        name: this.name,
        phone: this.phone,
        address: this.address,
        imageAvt: this.imageAvt);
  }
}

class Addinform extends State<Addinfo> {
  final String phone, name, address, imageAvt;
  TextEditingController Name = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController Phone = TextEditingController();
  TextEditingController Email = TextEditingController();
  File imageFile;
  bool isLoadingSave = false;
  bool isLoadingImage = true;
  String imageAvtt;

  Addinform({this.phone, this.name, this.address, this.imageAvt}) {
    Name.text = name;
    Address.text = address;
    Phone.text = phone;
    imageAvtt = imageAvt;
  }

  StorageReference firebaseStorageRef;
  Future UploadPic(BuildContext context) async {
    await FireBaseAuth().auth.currentUser().then((user) async {
      firebaseStorageRef =
          await FirebaseStorage.instance.ref().child(user.uid + ".jpg");
      await firebaseStorageRef.putFile(imageFile);
    }).catchError((err) {
      print('ảnh trống');
    });
  }

  Future _pickImageFromGallery(BuildContext context) async {
    final File picture =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => this.imageFile = picture);
    isLoadingImage = false;
    Navigator.of(context).pop();
  }

  Future _pickImageFromCamera(BuildContext context) async {
    final File picture =
        await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() => this.imageFile = picture);
    isLoadingImage = false;
    Navigator.of(context).pop();
  }

  Future<void> _Showchooseimage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    await _pickImageFromGallery(context);
                  },
                  child: Text("Thư viện ảnh"),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                GestureDetector(
                  child: Text("Máy ảnh"),
                  onTap: () async {
                    await _pickImageFromCamera(context);
                  },
                )
              ],
            ),
          ));
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(30)),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 95),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FlatButton(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: isLoadingImage
                                ? Image(
                                    image: NetworkImage(imageAvtt),
                                  )
                                : this.imageFile != null
                                    ? Image.file(
                                        this.imageFile,
                                        fit: BoxFit.fill,
                                      )
                                    : Icon(
                                        Icons.camera_alt,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _Showchooseimage(context);
                      }),
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 105, right: 15),
                  ),
                  Text(
                    "Chỉnh sửa ",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              )
            ],
          ),
          Expanded(
            child: Container(
                child: ListView(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: SahaTextField(
                    controller: Name,
                    labelText: "Họ và Tên ",
                    icon: Icon(
                      Icons.person,
                      color: Colors.green[800],
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: SahaTextField(
                    controller: Address,
                    labelText: " Địa chỉ ",
                    icon: Icon(
                      Icons.work,
                      color: Colors.green[800],
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: SahaTextField(
                    controller: Phone,
                    labelText: " Số điện thoại ",
                    icon: Icon(
                      Icons.phone,
                      color: Colors.green[800],
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
            ])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            isLoadingSave = true;
          });
          await FireBaseAuth().auth.currentUser().then((user) async {
            await UploadPic(context);
            await FirebaseDatabase.instance
                .reference()
                .child('info_user')
                .child(user.uid)
                .once()
                .then((data) {
              var map = data.value;
              map["Names"] = Name.text;
              map["Adress"] = Address.text;
              map["Phones"] = Phone.text;
              map["Emails"] = user.email;
              FirebaseDatabase.instance
                  .reference()
                  .child('info_user')
                  .child(user.uid)
                  .set(map);
            });

            await Future.delayed(const Duration(milliseconds: 2000), () {});
            setState(() {
              isLoadingSave = false;
            });
            Navigator.pop(
                context, MaterialPageRoute(builder: (context) => Info()));
          }).catchError((err) {
            setState(() {
              isLoadingSave = false;
            });

            print(err.toString());
          });
        },
        child: isLoadingSave
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
              )
            : Icon(Icons.save),
      ),
    );
  }
}
