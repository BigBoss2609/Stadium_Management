import 'package:rxdart/rxdart.dart';
import 'package:saha_owner/object/yard.dart';

class AddYardModalBloc {

    var controlCheck = new BehaviorSubject<String>();
    Stream get streamCheck => controlCheck.stream;

    void onAddYard({Yard yard, Function checkOK}) {
         if(yard.name == "") {
           controlCheck.add("Chưa nhập tên sân!");
         } else if(yard.typeYard == null ) {
           controlCheck.add("Loại sân không tồn tại!");
         } else {
           checkOK();
         }
    }

    void setCheckTypeYard() {
      controlCheck.add("Chưa chọn loại sân!");
    }

}