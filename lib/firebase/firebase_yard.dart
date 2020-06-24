import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:saha_owner/object/yard.dart';

class FireBaseYard {
  void addYard(
      {String idOwner, Yard yard, Function success, Function(String) failed}) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var ref = FirebaseDatabase.instance.reference().child("yard");

    firebaseAuth.currentUser().then((user) {
      ref
          .child(user.uid)
          .child(yard.typeYard.value)
          .push()
          .set(yard.name)
          .then((ok) {
        success();
      }).catchError((onError) {
        failed(onError.toString());
      });
    });
  }
}
