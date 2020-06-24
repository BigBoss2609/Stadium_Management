import 'package:flutter/material.dart';
import 'package:saha_owner/navigator/revenue/revenue.dart';
import 'package:saha_owner/navigator/yard/yard.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'book/book_yard.dart';
import 'info/info.dart';

class SahaNavigator extends StatefulWidget {
  final double openTime;
  final double closeTime;

  const SahaNavigator({Key key, this.openTime=1, this.closeTime=23}) : super(key: key);
  @override
  _SahaNavigatorState createState() => _SahaNavigatorState();
}

class _SahaNavigatorState extends State<SahaNavigator> {
  int _currentIndex = 0;
  DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    final _kYab = <Widget>[
      BookYard(openTime: widget.openTime, closeTime: widget.closeTime),
      Revenue(),
      Yard(),
      Info()
    ];
    final _kBottom = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(
            Icons.assignment,
          ),
          title: Text("Sân đã đặt")),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.attach_money,
          ),
          title: Text("Doanh thu")),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.build,
          ),
          title: Text("Thiết lập")),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.assignment_ind,
          ),
          title: Text("Cá nhân")),
    ];
    assert(_kYab.length == _kBottom.length);
    final bottomBar = BottomNavigationBar(
      items: _kBottom,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentIndex=index;
        });
      },
    );
    // TODO: implement build
    return Scaffold(
      body: WillPopScope(child: _kYab[_currentIndex], onWillPop: onWillPop),
      bottomNavigationBar: bottomBar,
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Nhấn thêm lần nữa để thoát");
      return Future.value(false);
    }
    return Future.value(true);
  }
}


