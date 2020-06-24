import 'package:flutter/foundation.dart';
import 'package:saha_owner/object/book_time.dart';
import 'package:saha_owner/object/yard.dart';

class BookYardBloc extends ChangeNotifier {
  DateTime dateTime;
  int indexTypeYard;
  int indexYard;
  List<Yard> yards;
  Map<String, dynamic> typeYards;
  bool loadingTypeYardAndYard;
  bool loadingLoadingBookYard;
  bool nullTypeYard;
  int indexDateTime;
  Map<String, dynamic> typeYardAndYard;
  String yard;
  String typeYard;
  List<BookTime> listBook;
  int hourStart;
  int hourStop;
  BookYardBloc() {
    nullTypeYard = false;
    listBook = new List<BookTime>();
    yards = new List<Yard>();
    loadingTypeYardAndYard = true;
    loadingLoadingBookYard = true;
    getListTypeYardAndYard();
    dateTime = DateTime.now();
    indexTypeYard = 0;
    indexDateTime = 0;
    dateTime = DateTime.now();
  }

  void setTimeSelected(DateTime time) {
    dateTime = time;
    getBookTimes();
  }

  void setIndexDateTime(int index) {
    indexDateTime = index;
    notifyListeners();
  }

  void setIndexTypeYard(int index) {
    indexTypeYard = index;
    typeYard = typeYardAndYard["data"].keys.toList()[index];
    getBookTimes();
    indexYard = 0;

    if (
    typeYardAndYard["data"][typeYard]["list"].length != null &&
        typeYardAndYard["data"][typeYard]["list"].length > 0) {
      yard = typeYardAndYard["data"][typeYard]["list"][0].id;
      getBookTimes();
    }

    notifyListeners();

  }

  void setIndexYard(int index) {
    indexYard = index;
    notifyListeners();
    if (typeYard != null && typeYard != "" &&
        typeYardAndYard["data"][typeYard]["list"] != null &&
    typeYardAndYard["data"][typeYard]["list"].length != null &&
        typeYardAndYard["data"][typeYard]["list"].length > 0) {
      yard = typeYardAndYard["data"][typeYard]["list"][index].id;
      getBookTimes();
    } else {
      nullTypeYard = true;
      loadingLoadingBookYard = false;
      notifyListeners();
    }
  }

  void getBookTimes() {

    if(typeYard == "" || typeYard == null) return;

    loadingLoadingBookYard = true;
    notifyListeners();

    BookTime bookTime = new BookTime();

    DateTime timeFirst =
        new DateTime(dateTime.year, dateTime.month, dateTime.day);
    DateTime timeEnd = new DateTime(dateTime.year, dateTime.month, dateTime.day)
        .add(new Duration(days: 1));

    bookTime
        .getListBookTime(
            typeYard: typeYard,
            yard: yard,
            timeFirst: timeFirst.millisecondsSinceEpoch,
            timeEnd: timeEnd.millisecondsSinceEpoch)
        .then((data) {

      listBook = data["data"];
      print(listBook);
      loadingLoadingBookYard = false;
      notifyListeners();
    }).catchError((err) {
      loadingLoadingBookYard = false;
      notifyListeners();
      print(err);
    });


  }

  void getListTypeYardAndYard() {
    loadingTypeYardAndYard = true;
    notifyListeners();
    var yard = new Yard();
    yard.getTypeYardAndYard().then((data) {
      typeYardAndYard = data;
      if (typeYardAndYard["data"].keys.toList().length > 0) {
        getYardOfUser(data["data"].keys.toList()[0]);
      }
      loadingTypeYardAndYard = false;
      setIndexYard(0);
      notifyListeners();
    }).catchError((err) {
      print(err);
      loadingTypeYardAndYard = false;
      notifyListeners();
    });
  }

  void getYardOfUser(String key) {
    typeYard = key;
    if (key != null) {
      yards = typeYardAndYard["data"][key]["list"];
      notifyListeners();
    }
  }

  void dispose() {
    super.dispose();
  }
}
