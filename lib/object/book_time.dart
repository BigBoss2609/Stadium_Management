import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class BookTime implements Comparable<BookTime> {
  String id;
  String name;
  String phone;
  double money;
  int timeStart;
  int timeStop;
  int timeAdd;
  String yard;
  String typeYard;

  BookTime(
      {this.id,
      this.yard,
      this.typeYard,
      this.name,
      this.phone,
      this.money,
      this.timeStart,
      this.timeStop,
      this.timeAdd});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "phone": phone,
      "money": money,
      "timeStart": timeStart,
      "timeStop": timeStop,
      "timeAdd": timeAdd,
    };
  }

  Future<Map<String, dynamic>> getListBookTime(
      {String typeYard, String yard, int timeFirst, int timeEnd}) async {
    var mapRT = new Map<String, dynamic>();
    var listReturn = new List<BookTime>();

    try {
      await FirebaseAuth.instance.currentUser().then((user) async {
        await FirebaseDatabase.instance
            .reference()
            .child("book")
            .child(user.uid)
            .child(typeYard)
            .child(yard)
            .child(getYear(timeFirst).toString())
            .orderByChild("timeStart")
            .startAt(timeFirst)
            .endAt(timeEnd)
            .once()
            .then((data) {
          if (data.value != null && data.value.length > 0) {
            data.value.forEach((key, value) {
              listReturn.add(new BookTime(
                  id: key,
                  name: value["name"],
                  phone: value["phone"],
                  yard: yard,
                  typeYard: typeYard,
                  money: double.parse(value["money"].toString()),
                  timeStart: value["timeStart"],
                  timeStop: value["timeStop"],
                  timeAdd: value["timeAdd"]));
            });

            mapRT["data"] = listReturn;
            mapRT["status"] = true;
            mapRT["mess"] = "Thanh cong";
          } else {
            mapRT["data"] = <BookTime>[];
            mapRT["status"] = true;
            mapRT["mess"] = "Thanh cong";
          }
        });
      });
    } catch (err) {
      print(err);
    }

    return mapRT;
  }

  int getMinuteInDayTimeStart() {
    DateTime time = new DateTime.fromMillisecondsSinceEpoch(timeStart);
    return time.hour * 60 + time.minute;
  }

  int getMinuteInDayTimeStop() {
    DateTime time = new DateTime.fromMillisecondsSinceEpoch(timeStop);
    return time.hour * 60 + time.minute;
  }

  int getYear(int milliseconds) {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return dateTime.year;
  }

  int getYearFromObject() {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(this.timeStart);
    return dateTime.year;
  }

  void deleteBookYard(
      {
      Function onSuccess,
      Function onFailed}) async {
    try {
      await FirebaseAuth.instance.currentUser().then((user) async {
        await FirebaseDatabase.instance
            .reference()
            .child("book")
            .child(user.uid)
            .child(typeYard)
            .child(yard)
            .child(getYearFromObject().toString())
            .child(id)
            .remove();
        onSuccess();
      });
    } catch (err) {
      onFailed(err);
    }
  }

  void addYard(
      {String typeYard,
      String yard,
      Function onSuccess,
      Function onFailed}) async {
    try {
      await FirebaseAuth.instance.currentUser().then((user) async {
        await FirebaseDatabase.instance
            .reference()
            .child("book")
            .child(user.uid)
            .child(typeYard)
            .child(yard)
            .child(getYear(this.timeStart).toString())
            .push()
            .set(toMap());
        onSuccess();
      });
    } catch (err) {
      onFailed();
      print(err);
    }
  }

  @override
  int compareTo(BookTime other) {
    if (this.timeStart > other.timeStart) return 1;
    if (this.timeStart < other.timeStart) return -1;
    return 0;
  }
}
