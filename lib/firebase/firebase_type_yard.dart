import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FireBaseTypeYard {



  void getListTypeFromFireBase({Function success, Function failed}) {
    var ref = FirebaseDatabase.instance.reference();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    firebaseAuth.currentUser().then((user) {
      ref.child("yard").child(user.uid).once()
          .then((DataSnapshot data) {
print("xxxxxxxxxx");
            print(data.value);
      //  success();
      }).catchError((onError) {
        print("Error"+onError.toString());
        failed(onError.toString());
      });
    });

  }

}