import 'package:flutter/material.dart';
import 'package:saha_owner/component/convert/convert.dart';
import 'package:saha_owner/object/book_time.dart';

class SelectTimeModalBloc extends ChangeNotifier {
  int start = 0; //second
  int end = 0; //second
  List<BookTime> listBook;

  SelectTimeModalBloc(List<BookTime> listBook) {
    this.listBook = listBook;
    start = 0;
    end = 0;
  }

  bool isCoincideTime() {
    int timeStartData;
    int timeStopData;
    bool isCoincide = false;
    for (BookTime itemBook in listBook) {
      timeStartData =
          SahaConvert.millisecondFirebaseToSecondInDay(itemBook.timeStart);
      timeStopData =
          SahaConvert.millisecondFirebaseToSecondInDay(itemBook.timeStop);

      bool check = (start > timeStartData && start < timeStopData) ||
          (end > timeStartData && end < timeStopData) || (start < timeStartData && end > timeStopData);
      if (check) {
        isCoincide = true;
        break;
      }
    }

    return isCoincide;
  }

  void setDuration(int start, int end) {
    this.start = start;
    this.end = end;
    notifyListeners();
  }
}
