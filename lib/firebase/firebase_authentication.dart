import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class FireBaseAuth {
  FirebaseAuth auth = FirebaseAuth.instance;

  static get instance => null;
  loginWithEmailPass(
      String email, String pass, Function onSuccess, Function faild)  {
    auth.signInWithEmailAndPassword(email: email, password: pass).then((v) {
      onSuccess();
    }).catchError((onError) {
      if(onError.code.toString() == "ERROR_USER_NOT_FOUND")
        {
          faild("Tài khoản không tồn tại");
          return;
        }
      if(onError.code.toString() == "ERROR_INVALID_EMAIL")
      {
        faild("Email không hợp lệ");
        return;
      }

      if(onError.code.toString() == "ERROR_WRONG_PASSWORD")
      {
        faild("Mật khẩu không đúng");
        return;
      }

      if(onError.code.toString() == "ERROR_USER_DISABLED")
      {
        faild("Tài khoản đã bị khóa");
        return;
      }


        faild("Kiểm tra thử lại");
        return;


    });
  }

  signUpWithEmailPassword(
      {String name,
        String email,
        String phone,
        String pass,
        String address,
        Function success,
        Function(String) faild})  {
    auth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((data)
    {
      data.user.uid;
      FireBaseAuth().auth.currentUser().then((user){
        FirebaseDatabase.instance.reference()
            .child('info_user')
            .child(user.uid)
            .set({
          'Phones':phone,
          'Names':name,
          'Emails':email,
        }
        );
      });
      success();
    })
        .catchError((err) {
          if(err.code.toString() == "ERROR_WEAK_PASSWORD")
            {
              faild("Mật khẩu yếu");
              return;
            }

          if(err.code.toString() == "ERROR_EMAIL_ALREADY_IN_USE")
          {
            faild("Email đã được sử dụng");
            return;
          }

          if(err.code.toString() == "ERROR_INVALID_EMAIL")
          {
            faild("Email không hợp lệ");
            return;
          }


            faild("Kiểm tra @gmaithử lại");
            return;



    });
  }
}