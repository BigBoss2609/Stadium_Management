import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TypeYard {
  String name;
  String value;
  TypeYard({this.name, this.value});

  factory TypeYard.fromJson(Map<String, dynamic> item) => TypeYard(
        name: "item.keys.toString()",
        value: "item",
      );

  static List<TypeYard> listTypeYardLocal() {
    var typeYards = new List<TypeYard>();
    typeYards.add(new TypeYard(name: "Sân 5x5", value: "5x5"));
    typeYards.add(new TypeYard(name: "Sân 7x7", value: "7x7"));
    typeYards.add(new TypeYard(name: "Sân 9x9", value: "9x9"));
    return typeYards;
  }

  Future<Map<String,dynamic>> getListYardOfUser() async {

    var mapRT = new Map<String,dynamic>();

    TypeYard typeYard = new TypeYard();
    var mapTypeYard = new Map<String,String>();
    await typeYard.getMapTypeYard().then((map){
      mapTypeYard = map;
    });

    var listReturn = new List<TypeYard>();

    await FirebaseAuth.instance.currentUser().then((user) async{
      await  FirebaseDatabase.instance.reference().child("yard").child(user.uid).once().then((data){
       if(data.value != null) {
         data.value.forEach(
                 (key, value) {
               listReturn.add(new TypeYard(name: key, value: mapTypeYard[key]));
             }
         );
       }
        mapRT["data"] = listReturn;
        mapRT["mess"] = "Thanh cong";
        mapRT["status"] = true;
      });
    }).catchError((err) {
      mapRT["mess"] = err.toString();
      mapRT["status"] = false;
    });

    return mapRT;
  }

  Future<List<TypeYard>> getListTypeYard() async {
    var listReturn = new List<TypeYard>();

    await FirebaseDatabase.instance
        .reference()
        .child("type_yard")
        .once()
        .then((data) {
      data.value.forEach(
          (key,value) {
            listReturn.add(new TypeYard(name:key,value: value));
          }
      );

    }).catchError((onError) {
      print("Error:  " + onError.toString());
      return null;
      //failed(onError.toString());
    });

    return listReturn;
  }

  Future<Map<String,String>> getMapTypeYard() async {
    var mapReturn = new Map<String,String>();

    await FirebaseDatabase.instance
        .reference()
        .child("type_yard")
        .once()
        .then((data) {
      data.value.forEach(
              (key,value) {
                mapReturn[key] = value;
          }
      );

    }).catchError((onError) {
      print("Error:  " + onError.toString());
      return null;
      //failed(onError.toString());
    });

    return mapReturn;
  }
}
