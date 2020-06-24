import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saha_owner/object/user.dart';

class InfoBloc extends ChangeNotifier {

  bool loadingUser = false;

  var controlUser = new BehaviorSubject();
  Stream get streamUser => controlUser.stream;
  User user = new User();

  InfoBloc() {
    getUser();
  }
  void getUser() {

    loadingUser = true;
    notifyListeners();
    user.getUser().then((data) {
      controlUser.add(data);
      loadingUser = false;
      notifyListeners();
    });
    notifyListeners();
  }




}