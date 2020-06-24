import 'package:firebase_database/firebase_database.dart';

class User {
  String email;

  Future<Map<String, dynamic>> getUser() async {
    var mapRT = new Map<String, dynamic>();

    await FirebaseDatabase.instance.reference().once().then((data) {
      User data = new User();
      data.email = "xxx";

      mapRT["status"] = true;
      mapRT["data"] = data;
      mapRT["mess"] = "Thanh cong";
    }).catchError((err) {
      mapRT["status"] = false;
      mapRT["mess"] = "That bat";
    });

    return mapRT;
  }
}
