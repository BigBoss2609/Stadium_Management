import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:saha_owner/component/button/saha_back_button.dart';
import 'package:saha_owner/object/book_time.dart';
import 'detail_revenue_bloc.dart';

class DetailRevenue extends StatelessWidget {
  final String yardName;
  final List<BookTime> listBook;

  const DetailRevenue({Key key, this.yardName, this.listBook}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFEDFE9F7),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: new LinearGradient(
                  colors: [Color(0xFFE54DB63), Color(0xFFE00BFA5)],
                  begin: Alignment.centerRight,
                  end: new Alignment(0.8, -1)),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(30)),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 90),
                      child: SahaBackButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 90),
                      child: Text(
                        yardName,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 40, right:20, bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.all(10),
                          itemCount: listBook.length,
                          itemBuilder: (context,index) {
                            FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: listBook[index].money);
                            DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(listBook[index].timeStop);
                            DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(listBook[index].timeStart);
                            int sumMinute = dateTime2.hour*60+dateTime2.minute - (dateTime1.hour*60+dateTime1.minute);
                            String spaceTime = sumMinute < 60
                                ? (sumMinute).toString() + " phút"
                                : (sumMinute ~/ 60).toString() +
                                " giờ" +
                                " " +
                                ((((sumMinute - (sumMinute ~/ 60) * 60))) ~/ 1).toString() +
                                " phút";
                            return ListTile(
                              title: Text(listBook[index].name),
                              subtitle: Text(spaceTime),
                              trailing: Text(fmf.output.withoutFractionDigits + "đ"),
                            );
                      }),
                    ),
                  ),
                ),
              ],
          ),
        ],
      ),
    );
  }

  Widget buildDateItem(
      {BuildContext context, DateTime dataTime, bool selected}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: new Container(
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: selected ? Colors.green : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: SizedBox(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: Text("tháng " + dataTime.month.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: selected ? Colors.white : Colors.black,
                            fontFamily: 'Roboto')),
                  ),
                  new Container(
                    child: (DateTime.now().day == dataTime.day &&
                        DateTime.now().month == dataTime.month &&
                        DateTime.now().year == dataTime.year)
                        ? Padding(
                        padding: EdgeInsets.all(2),
                        child: Text("Hôm nay",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color:
                                selected ? Colors.white : Colors.black,
                                fontFamily: 'Roboto')))
                        : Text(
                      dataTime.day.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : Colors.black,
                          fontFamily: 'Roboto'),
                    ),
                  ),
                  new Container(
                    child: Text((dataTime.weekday ==7? "Chủ Nhật": "Thứ "+ (dataTime.weekday+1).toString()),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: selected ? Colors.white : Colors.black,
                            fontFamily: 'Roboto')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}