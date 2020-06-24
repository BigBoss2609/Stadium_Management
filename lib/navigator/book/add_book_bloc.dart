import 'package:flutter/foundation.dart';
import 'package:saha_owner/object/book_time.dart';
import 'package:saha_owner/object/yard.dart';

class AddBookBloc extends ChangeNotifier {
  DateTime dateTime;
  Map<String, dynamic> typeYardAndYard;
  int indexTypeYard;
  int indexYard;
  List<Yard> yards;
  int timeStart;
  int timeStop;
  String yard;
  String typeYard;
  List<BookTime> listBook;
  bool isTimeAvailable;
  int hourStart;
  int hourStop;

  AddBookBloc() {
    indexTypeYard = 0;
    indexYard = 0;
    timeStart=0;
    timeStop=0;
    isTimeAvailable= false;

  }

  void setIndexTypeYard(int index) {
    indexTypeYard = index;
    notifyListeners();
  }

  void setTimeDuration(int start,int end) {
    timeStop = end;
    timeStart = start;
    notifyListeners();
  }

  void setIndexYard(int index) {
    indexYard = index;
    notifyListeners();
  }

  void getYardOfUser(String key) {
    if (key != null) {
      yards = typeYardAndYard["data"][key]["list"];
      notifyListeners();
    }
  }
}