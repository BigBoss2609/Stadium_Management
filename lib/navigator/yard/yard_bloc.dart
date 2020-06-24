import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saha_owner/component/dialog/saha_dialog_yes_no.dart';
import 'package:saha_owner/firebase/firebase_type_yard.dart';
import 'package:saha_owner/firebase/firebase_yard.dart';
import 'package:saha_owner/object/type_yard.dart';
import 'package:saha_owner/object/yard.dart';

import 'add_yard_modal.dart';

class YardBloc extends ChangeNotifier {
  YardBloc() {
    getListTypeOfUser();
  }

  var indexTypeYard = 0;

  FireBaseTypeYard fireBaseTypeYard = new FireBaseTypeYard();
  FireBaseYard fireBaseYard = new FireBaseYard();

  var controlDataTypeYard = new BehaviorSubject<dynamic>();
  Stream get streamTypeYards => controlDataTypeYard.stream;

  var loadingYards = true;
  var loadingTypeYards = true;

  var controlDataYard = new BehaviorSubject<dynamic>();
  Stream get streamYards => controlDataYard.stream;

  void setIndexType(int index) {
    indexTypeYard = index;
    notifyListeners();
  }

  void getListTypeOfUser() {
    loadingTypeYards = true;
    notifyListeners();
    var typeYard = new TypeYard();
    typeYard.getListYardOfUser().then((dataTypeYards) {
      controlDataTypeYard.add(dataTypeYards);

      if(dataTypeYards["status"] == true) {

        if (dataTypeYards["data"].isNotEmpty) {
          getYardOfUser(dataTypeYards["data"][0].name);
          loadingTypeYards = false;
          notifyListeners();
        } else {
          getYardOfUser(null);
          loadingTypeYards = false;
          notifyListeners();
        }
        loadingTypeYards = false;
        notifyListeners();

      }

    });
  }

  void getYardOfUser(String key) {
    if (key != null) {
      loadingYards = true;
      notifyListeners();
      var yard = new Yard();
      yard.getListYardWithType(key).then((dataYards) {
        controlDataYard.add(dataYards);
        loadingYards = false;

        notifyListeners();
      }).catchError((err) {
        print(err);
        loadingYards = false;

        notifyListeners();
      });
    } else {
      var mapNull = new Map<String, dynamic>();
      mapNull["status"] = true;
      mapNull["data"] = [];
      controlDataYard.add(mapNull);
      loadingYards = false;
      notifyListeners();
    }
  }

  void addYard({Yard yard, Function success, Function(String) failed}) {
    fireBaseYard.addYard(yard: yard, success: success, failed: failed);
  }

  void getYardFromFireBase() {
    //fireBaseTypeYard.getListTypeFromFireBase();
  }

  void showModalEdit(BuildContext context, Yard yard) {
    var textName = new TextEditingController(text: yard.name);
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller:textName,
            )
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Sửa"),
              onPressed: () {
                yard.editYard(success: () {
                  getYardOfUser(yard.typeYard.name);
                  print("Success");
                }, failed: (err) {
                  print("Failed");
                }, newName: textName.text);
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Hủy"),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  void showDialogRemove(BuildContext context, Yard yard) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SahaDiaLogYesNo(
              title: "Xác nhận",
              content: "Bạn đồng ý xóa sân này!",
              onYes: () {
                yard.deleteYard(success: () {
                  getYardOfUser(yard.typeYard.name);
                  Navigator.maybePop(context);
                  print("xoa thanh cong");
                }, failed: (err) {
                  Navigator.maybePop(context);
                  print("xoa that bai");
                });
              },
              onNo: () {},
            ));
  }

  void onPressAddYard(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddYardModal(
            onAdd: (yard) {
              addYard(
                  yard: yard,
                  success: () {
                    Navigator.of(context).maybePop();
                    getListTypeOfUser();
                    getYardOfUser(yard.typeYard.value);
                  },
                  failed: (err) {
                    print(err.toString());
                  });
            },
          );
        });
  }
}
