import 'package:rxdart/rxdart.dart';
import 'package:saha_owner/firebase/firebase_authentication.dart';
class LoginBloc {
  FireBaseAuth fireBaseAuth = new FireBaseAuth();

  // ignore: close_sinks
  BehaviorSubject<bool> controlLoading = new BehaviorSubject<bool>();
  Stream get loadingStream => controlLoading.stream;

  // ignore: close_sinks
  BehaviorSubject<String> controlEmail = new BehaviorSubject<String>();
  Stream get emailStream => controlEmail.stream;

  void loginWithEmailPassword(String email, String pass, Function sucsess, Function(String) faild) {
    controlLoading.sink.add(true);
    fireBaseAuth.loginWithEmailPass(email, pass, sucsess, faild);

  }

  void setLoading(bool state) {
    controlLoading.sink.add(state);
  }

  void setInfo(String k) {

     controlEmail.sink.add(k);
  }

}