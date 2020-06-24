import 'package:flutter/foundation.dart';
import 'package:saha_owner/object/book_time.dart';
import 'package:saha_owner/object/yard.dart';

class DetailRevenueBloc extends ChangeNotifier{
  DateTime dateTime;
  int indexDateTime;
  DetailRevenueBloc(){
    dateTime = DateTime.now();
    indexDateTime =0;
    dateTime = DateTime.now();
  }

  void setTimeSelected(DateTime time) {
    dateTime = time;
  }

  void setIndexDateTime(int index) {
    indexDateTime = index;
    notifyListeners();
  }
}