
import 'package:rxdart/rxdart.dart';
import 'package:saha_owner/firebase/firebase_authentication.dart';

class SignUpBloc {
  FireBaseAuth fireBaseAuth = new FireBaseAuth();

  BehaviorSubject<bool> controlLoading = new BehaviorSubject<bool>();
  Stream get loadingStream => controlLoading.stream;

  // ignore: close_sinks
  BehaviorSubject<String> controlError = new BehaviorSubject<String>();
  Stream get errorStream => controlLoading.stream;

  void signUpWithEmailPassword({String name, String email, String phone, String pass, String address, Function success, Function(String) faild}) {
    controlLoading.add(true);
    fireBaseAuth.signUpWithEmailPassword(email: email, pass: pass, name: name, address: address, faild: faild, phone: phone, success: success);
  }

  void sendError(String err) {
    controlError.sink.add(err);
  }

  void setLoading(bool state) {
    controlLoading.sink.add(state);
  }

}