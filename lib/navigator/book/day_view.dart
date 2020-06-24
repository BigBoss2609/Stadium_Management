import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:saha_owner/component/button/saha_button_blue.stateless.dart';
import 'package:saha_owner/component/dialog/saha_dialog_loading.dart';
import 'package:saha_owner/component/dialog/saha_dialog_yes_no.dart';
import 'package:saha_owner/object/book_time.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DayView extends StatelessWidget {
  final double hourStart;
  final List<BookTime> listBookTime;
  final double hourStop;
  BuildContext contextMain;
  final bool isLoading;
  final Function(bool) onChange;

  DayView(
      {this.hourStart,
      this.hourStop,
      this.contextMain,
      this.isLoading = true,
      this.listBookTime, this.onChange});

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    return girdBody(
        context: context,
        hourStart: hourStart,
        hourStop: hourStop,
        isLoading: isLoading);
  }

  Widget girdBody(
      {BuildContext context, double hourStart, double hourStop, bool isLoading}) {
    var rows = List<Widget>();
    for (int indexRow = 0; indexRow <= hourStop - hourStart; indexRow++) {
      rows.add(
        rowDayView((hourStart + indexRow) ~/1),
      );
    }

    var fullRowsAndItem = List<Widget>();
    fullRowsAndItem.add(Column(children: rows));

    if (isLoading) {
      for (int indexLoad = 0; indexLoad <= hourStop - hourStart; indexLoad++) {
        fullRowsAndItem.add(
          itemLoading(index: indexLoad),
        );
      }
    } else {
      for (BookTime indexItemCustomer in listBookTime) {
        int timeStart =
            DateTime.fromMillisecondsSinceEpoch(indexItemCustomer.timeStart)
                        .hour *
                    3600 +
                DateTime.fromMillisecondsSinceEpoch(indexItemCustomer.timeStart)
                        .minute *
                    60;
        int timeStop =
            DateTime.fromMillisecondsSinceEpoch(indexItemCustomer.timeStop)
                        .hour *
                    3600 +
                DateTime.fromMillisecondsSinceEpoch(indexItemCustomer.timeStop)
                        .minute *
                    60;

        fullRowsAndItem.add(
          itemCustomer(
              hourStart: hourStart,
              timeStart: timeStart,
              timeStop: timeStop,
              name: indexItemCustomer.name,
              phone: indexItemCustomer.phone,
              money: indexItemCustomer.money,
              onRemove: () {
                showDialog(
                  barrierDismissible: false,
                    context: context,
                    builder: (context) => SahaDialogLoading());
                indexItemCustomer.deleteBookYard(onSuccess: () {
                  print("Delete success");
                  onChange(true);
                  Navigator.pop(context);
                }, onFailed: (err) {
                  print("Messege: " + err.toString());
                  Navigator.pop(context);
                });
              }),
        );
      }
    }

    return SingleChildScrollView(child: Stack(children: fullRowsAndItem));
  }

  Widget itemLoading({int index}) {
    double topPadding = (index * 100) + .0;
    return Positioned(
        top: topPadding,
        right: 10,
        child: Container(
            width: MediaQuery.of(contextMain).size.width * 0.75,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[350],
                      highlightColor: Colors.white,
                      child: Container(
                        height: 10,
                        width: MediaQuery.of(contextMain).size.width * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200],
                      highlightColor: Colors.white,
                      child: Container(
                        height: 10,
                        width: MediaQuery.of(contextMain).size.width * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Shimmer.fromColors(
                          baseColor: Colors.grey[350],
                          highlightColor: Colors.white,
                          child: Container(
                            height: 15,
                            width: MediaQuery.of(contextMain).size.width * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  ],
                )
              ],
            )));
  }

  void buildModalBottomSheetInfo(
      {BuildContext context,
      String name,
      String spaceTime,
      String money,
      String phone,
      String timeStart,
      String timeStop,
      Function onRemove}) {
    showModalBottomSheet(
        context: context,
        builder: (bc) => Container(
              padding: EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(Icons.account_circle),
                        Text("  Người đặt"),
                      ],
                    ),
                    trailing: Text(
                      name,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(Icons.timer),
                        Text("  Thời gian"),
                      ],
                    ),
                    trailing: Text(
                      timeStart + " - " + timeStop,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(Icons.access_time),
                        Text("  Tổng thời gian"),
                      ],
                    ),
                    trailing: Text(
                      spaceTime,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(Icons.attach_money),
                        Text("  Số tiền"),
                      ],
                    ),
                    trailing: Text(
                      money + "đ",
                      style: TextStyle(color: Colors.green, fontSize: 17),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      launch("tel:" + phone);
                    },
                    title: Row(
                      children: <Widget>[
                        Icon(Icons.phone),
                        Text("  Số điện thoại"),
                      ],
                    ),
                    trailing: Text(
                      phone,
                      style: TextStyle(color: Colors.blue, fontSize: 17),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 45,
                          width: 150,
                          child: Center(
                            child: Text("Xóa",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => SahaDiaLogYesNo(
                                    title: "Chú ý!",
                                    content: "Bạn chắc chắn muốn xóa?",
                                    onYes: () {
                                      Navigator.pop(context);
                                      onRemove();
                                    },
                                onNo: () {
                                  Navigator.pop(context);
                                },
                                  ));
                        },
                      )
                    ],
                  )
                ],
              ),
            ));
  }

  Widget itemCustomer(
      {double hourStart,
      String name,
      String phone,
      int timeStart,
      int timeStop,
      double money,
      Function onRemove}) {
    double topPadding = (timeStart / 3600) * 100 - (100 * hourStart);

    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: money);
    String moneyString = fmf.output.withoutFractionDigits;
    int sumSec = timeStop - timeStart;
    String spaceTime = sumSec < 3600
        ? (sumSec / 60).toString() + " phút"
        : (sumSec ~/ 3600).toString() +
            " giờ" +
            " " +
            ((((sumSec - (sumSec ~/ 3600) * 3600)) / 60) ~/ 1).toString() +
            " phút";

    String timeStartString = (timeStart ~/ 3600).toString() +
        "h" +
        ((timeStart - (timeStart ~/ 3600 * 3600)) / 60 ~/ 1).toString() +
        "p";
    String timeStopString = (timeStop ~/ 3600).toString() +
        "h" +
        ((timeStop - (timeStop ~/ 3600 * 3600)) / 60 ~/ 1).toString() +
        "p";

    double heightItemCustomer = ((timeStop - timeStart) / 3600 * 100);
    return Positioned(
      top: topPadding,
      right: 0,
      child: MaterialButton(
        onPressed: () {
          buildModalBottomSheetInfo(
              context: contextMain,
              name: name,
              phone: phone,
              timeStart: timeStartString,
              timeStop: timeStopString,
              money: moneyString,
              spaceTime: spaceTime,
              onRemove: onRemove);
        },
        padding: EdgeInsets.all(0),
        child: Container(
          padding: EdgeInsets.all(15),
          color: Colors.greenAccent,
          height: heightItemCustomer,
          width: MediaQuery.of(contextMain).size.width * 0.78,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    style: TextStyle(
                        height: 1.3, fontSize: 17, color: Colors.black54),
                    children: [
                      TextSpan(text: name + "\n"),
                      TextSpan(text: fmf.output.withoutFractionDigits + "đ"),
                    ]),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(timeStartString,
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      Text("-"),
                      Text(timeStopString,
                          style: TextStyle(fontWeight: FontWeight.w300)),
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  MaterialButton(
                    onPressed: () {
                      launch("tel:" + phone);
                    },
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          phone + " ",
                          style: TextStyle(
                              height: 1.3,
                              fontSize: 17,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.call,
                          size: 20,
                        )
                      ],
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

  Widget rowDayView(int hour) {
    double height = 100;
    return Container(
      height: height,
      child: Stack(
        children: <Widget>[
          MySeparator(
            color: Colors.grey,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      hour.toString().padLeft(2, "0") + ":00",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.lightBlueAccent,
                    height: 35,
                    width: 5,
                  ),
                  Icon(
                    Icons.radio_button_unchecked,
                    size: 17,
                    color: Colors.blueAccent,
                  ),
                  Container(
                    color: Colors.lightBlueAccent,
                    height: 35,
                    width: 5,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
