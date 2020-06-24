import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saha_owner/component/button/saha_back_button.dart';
import 'package:saha_owner/component/button/saha_button_blue.stateless.dart';
import 'package:saha_owner/component/dialog/saha_dialog_error.dart';
import 'package:saha_owner/component/dialog/saha_dialog_loading.dart';
import 'package:saha_owner/component/time/time_duration.dart';
import 'package:saha_owner/object/book_time.dart';
import 'package:saha_owner/object/yard.dart';
import 'add_book_bloc.dart';
import 'book_yard_bloc.dart';
import 'select_time_modal/select_time_modal.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class AddBookYard extends StatelessWidget {
  final BookYardBloc bookYardBloc;

  const AddBookYard({Key key, this.bookYardBloc}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => AddBookBloc(),
        )
      ],
      child: BodyAddBookYard(
        bookYardBloc: bookYardBloc,
      ),
    );
  }
}

class BodyAddBookYard extends StatelessWidget {
  final BookYardBloc bookYardBloc;

  const BodyAddBookYard({Key key, this.bookYardBloc}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AddBookBloc addBookBloc = Provider.of<AddBookBloc>(context);
    addBookBloc.typeYardAndYard = bookYardBloc.typeYardAndYard;
    addBookBloc.yards = bookYardBloc.yards;
    addBookBloc.indexYard = bookYardBloc.indexYard;
    addBookBloc.indexTypeYard = bookYardBloc.indexTypeYard;
    addBookBloc.dateTime = bookYardBloc.dateTime;
    addBookBloc.yard = bookYardBloc.yard;
    addBookBloc.typeYard = bookYardBloc.typeYard;
    addBookBloc.listBook = bookYardBloc.listBook;
    addBookBloc.hourStart = bookYardBloc.hourStart;
    addBookBloc.hourStop = bookYardBloc.hourStop;
    return new Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 25, top: 50, right: 5),
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [Color(0xFFE54DB63), Color(0xFFE00BFA5)],
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(),
                                child: SahaBackButton(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(),
                                child: Text(
                                  'Thêm người đặt ',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, right: 20),
                            child: new Container(
                              height: 500,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              child: new MyHomePage(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {


  const MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textEditingControllerName = new TextEditingController();

  TextEditingController textEditingControllerPhone =
      new TextEditingController();

  String moneyText = "0";

  TextEditingController textEditingControllerMoney =
  new MaskedTextController(mask: '000.000.000.000');

  Widget build(BuildContext context) {
    AddBookBloc addBookBloc = Provider.of<AddBookBloc>(context);
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Thêm người đặt: ",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Text(
                      addBookBloc.dateTime.day.toString() +
                          "/" +
                          addBookBloc.dateTime.month.toString() +
                          "/" +
                          addBookBloc.dateTime.year.toString(),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[DropDownTypeYard(), DropDownYard()],
                ),
                new ListTile(
                  leading: const Icon(Icons.person),
                  title: new TextField(
                    controller: textEditingControllerName,
                    decoration: new InputDecoration(
                      hintText: "Tên",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.phone),
                  title: new TextField(
                    controller: textEditingControllerPhone,
                    keyboardType: TextInputType.phone,
                    decoration: new InputDecoration(
                      hintText: "Số điện thoại",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.money_off),
                  title: new TextField(

                    showCursor: false,
                    controller: textEditingControllerMoney,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      suffixText: "VND",
                      suffixStyle: TextStyle(color: Colors.grey),
                      hintText: " Giá tiền ",
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: MaterialButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) {
                              return SelectTimeModal(
                                hourStart: addBookBloc.hourStart,
                                hourStop: addBookBloc.hourStop,
                                onChange: (start, end) {
                                  addBookBloc.setTimeDuration(start, end);
                                },
                                listBook: addBookBloc.listBook,
                              );
                            });
                      },
                      child: TimeDuration(
                        timeStop: addBookBloc.timeStop,
                        timeStart: addBookBloc.timeStart,
                      )),
                ),
                SizedBox(height: 10),
                Center(
                  child: SahaButton(
                    child: Text(
                      "Thêm",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    onPressed: () {

                      if (textEditingControllerName.text.length == 0 ||
                          textEditingControllerPhone.text.length == 0 ||
                      textEditingControllerMoney.text.length == 0) {
                        showDialog(
                            context: context,
                            builder: (context) => SahaDiaLogError(
                                  title: "Lỗi!",
                                  content: "Hãy nhập đầy đủ thông tin khách hàng",
                                ));

                        return;
                      }

                      if(addBookBloc.timeStop - addBookBloc.timeStart == 0) {
                        showDialog(
                            context: context,
                            builder: (context) => SahaDiaLogError(
                              title: "Lỗi!",
                              content: "Thời gian trận đấu không hợp lệ",
                            ));

                        return;
                      }

                      showDialog(
                        barrierDismissible: false,
                          context: context,
                          builder: (context) => SahaDialogLoading());

                        int year = addBookBloc.dateTime.year;
                        int month = addBookBloc.dateTime.month;
                        int day = addBookBloc.dateTime.day;

                        int timeStart = DateTime(year, month, day)
                            .add(new Duration(seconds: addBookBloc.timeStart))
                            .millisecondsSinceEpoch;
                        int timeStop = DateTime(year, month, day)
                            .add(new Duration(seconds: addBookBloc.timeStop))
                            .millisecondsSinceEpoch;

                        BookTime bookTime = new BookTime(
                            timeStart: timeStart,
                            timeStop: timeStop,
                            phone: textEditingControllerPhone.text,
                            money: double.parse(textEditingControllerMoney.text.replaceAll(".", "")),
                            name: textEditingControllerName.text,
                            timeAdd: DateTime.now().millisecondsSinceEpoch);

                        bookTime.addYard(
                            typeYard: addBookBloc.typeYard,
                            yard: addBookBloc.yard,
                            onFailed: () {
                              //  Navigator.maybePop(context);
                            },
                            onSuccess: () {
                              Navigator.pop(context);
                              Navigator.pop(context, true);
                            });

                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DropDownTypeYard extends StatelessWidget {
  var listDropType = new List<DropdownMenuItem<int>>();

  @override
  Widget build(BuildContext context) {
    AddBookBloc addBookBloc = Provider.of<AddBookBloc>(context);

    if (addBookBloc.typeYardAndYard["data"].length > 0) {
      listDropType.clear();

      int i = 0;
      addBookBloc.typeYardAndYard["data"].forEach((key, value) {
        listDropType.add(DropdownMenuItem<int>(
          child: Text(value["name"],
              style: TextStyle(
                fontSize: 20.0,
              )),
          value: i,
        ));
        i++;
      });
    }

    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: SizedBox(
        child: DropdownButton<int>(
          iconSize: 30,
          items: listDropType,
          onChanged: (int index) {
            addBookBloc.setIndexYard(0);
            addBookBloc.setIndexTypeYard(index);

            addBookBloc.getYardOfUser(
                addBookBloc.typeYardAndYard["data"].keys.toList()[index]);
          },
          hint: Text(
            'Chọn sân',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          value: addBookBloc.indexTypeYard,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DropDownYard extends StatelessWidget {
  var listDropYard = new List<DropdownMenuItem<int>>();

  @override
  Widget build(BuildContext context) {
    AddBookBloc addBookBloc = Provider.of<AddBookBloc>(context);

    if (addBookBloc.yards != null ||
        addBookBloc.yards.length != null ||
        addBookBloc.yards.length > 0) {
      listDropYard.clear();

      int i = 0;
      for (Yard itemYard in addBookBloc.yards) {
        listDropYard.add(DropdownMenuItem<int>(
          child: Text(itemYard.name,
              style: TextStyle(
                fontSize: 20.0,
              )),
          value: i,
        ));
        i++;
      }
    }

    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: SizedBox(
        child: DropdownButton<int>(
          iconSize: 30,
          items: listDropYard,
          onChanged: (int value) {
            addBookBloc.setIndexYard(value);
          },
          hint: Text(
            'Chọn sân',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          value: addBookBloc.indexYard,
        ),
      ),
    );
  }
}
