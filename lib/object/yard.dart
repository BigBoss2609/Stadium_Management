import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'type_yard.dart';

class Yard {
  String id;
  String name;
  TypeYard typeYard;

  String get getName => name;

  Yard({this.id, this.name, this.typeYard});

  void editYard({Function success, Function(String) failed, String newName}) {
    FirebaseAuth.instance.currentUser().then((user) {
      FirebaseDatabase.instance
          .reference()
          .child("yard")
          .child(user.uid)
          .child(typeYard.name)
          .once()
          .then((data) {
        var map = data.value;
        map[id] = newName;

        FirebaseDatabase.instance
            .reference()
            .child("yard")
            .child(user.uid)
            .child(typeYard.name)
            .set(map)
            .then((data2) {
          success();
        }).catchError((err) {});
      }).catchError((err) {
        failed(err);
      });
    });
  }

  void deleteYard({Function success, Function(String) failed}) {
    FirebaseAuth.instance.currentUser().then((user) {
      FirebaseDatabase.instance
          .reference()
          .child("yard")
          .child(user.uid)
          .child(typeYard.name)
          .child(id)
          .remove()
          .then((ok) {
        success();
      }).catchError((err) {
        failed(err);
      });
    });
  }

  Future<Map<String, dynamic>> getTypeYardAndYard() async {
    var mapData = new Map<String, dynamic>();
    var mapRT = new Map<String, dynamic>();
    TypeYard typeYard = new TypeYard();
    var mapTypeYard = new Map<String, String>();
    await typeYard.getMapTypeYard().then((map) {
      mapTypeYard = map;
    });

    await FirebaseAuth.instance.currentUser().then((user) async {
      await FirebaseDatabase.instance
          .reference()
          .child("yard")
          .child(user.uid)
          .once()
          .then((dataTypeAndYard) {
        if (dataTypeAndYard.value.length > 0) {
          dataTypeAndYard.value.forEach((type, dataYard) {
            mapData[type] = new Map<String, dynamic>();
            mapData[type]["name"] = mapTypeYard[type];
            mapData[type]["list"] = new List<Yard>();

            dataYard.forEach((id, name) {
              mapData[type]["list"].add(new Yard(
                  id: id,
                  name: name,
                  typeYard:
                      new TypeYard(name: type, value: mapTypeYard[type])));
            });

            mapRT["data"] = mapData;
            mapRT["status"] = true;
            mapRT["mess"] = "Thanh cong";
          });
        }
      }).catchError((err) {
        mapRT["data"] = mapData;
        mapRT["status"] = false;
        mapRT["mess"] = "Loi";
        print(err.toString());
        return mapRT;
      });
    }).catchError((err) {
      mapRT["data"] = mapData;
      mapRT["status"] = false;
      mapRT["mess"] = "Loi";

      print(err.toString());
      return mapRT;
    });

    return mapRT;
  }

  Future<Map<String, dynamic>> getListYardWithType(String keyType) async {
    var mapRT = new Map<String, dynamic>();
    TypeYard typeYard = new TypeYard();
    var mapTypeYard = new Map<String, String>();
    await typeYard.getMapTypeYard().then((map) {
      mapTypeYard = map;
    });

    var listReturn = new List<Yard>();

    await FirebaseAuth.instance.currentUser().then((user) async {
      await FirebaseDatabase.instance
          .reference()
          .child("yard")
          .child(user.uid)
          .child(keyType)
          .once()
          .then((data) {
        if (data.value.length > 0) {
          data.value.forEach((key, value) {
            listReturn.add(new Yard(
                name: value,
                id: key,
                typeYard:
                    new TypeYard(name: keyType, value: mapTypeYard[keyType])));
          });
          mapRT["data"] = listReturn;
          mapRT["status"] = true;
          mapRT["mess"] = "Thanh cong";
        }
      }).catchError((err) {
        mapRT["data"] = listReturn;
        mapRT["status"] = false;
        mapRT["mess"] = "Loi";
        print(err.toString());
        return mapRT;
      });
    }).catchError((err) {
      mapRT["data"] = listReturn;
      mapRT["status"] = false;
      mapRT["mess"] = "Loi";

      print(err.toString());
      return mapRT;
    });

    return mapRT;
  }
}
