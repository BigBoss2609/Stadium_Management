import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:provider/provider.dart';
import 'package:saha_owner/component/button/saha_button_blue.stateless.dart';
import 'package:saha_owner/navigator/book/book_yard_bloc.dart';
import 'package:saha_owner/navigator/revenue/detail_revenue.dart';
import 'package:saha_owner/navigator/revenue/revenue_bloc.dart';
import 'package:saha_owner/object/book_time.dart';
import 'package:saha_owner/object/yard.dart' as prefix0;

class Revenue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => RevenueBloc(),
        )
      ],
      child: RevenueBody(),
    );
  }
}

// ignore: must_be_immutable
class RevenueBody extends StatelessWidget {
  BuildContext contextMain;

  @override
  Widget build(BuildContext context) {
    RevenueBloc revenueBloc = Provider.of<RevenueBloc>(context);
    contextMain = context;
    return Scaffold(

      backgroundColor: Color(0xFFEDFE9F7),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.24,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 70, left: 30),
                    child: Text(
                      "Sân đã đặt",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.11,
                padding: const EdgeInsets.only(left: 5.0),
                child: InfiniteListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          revenueBloc.setIndexDateTime(index);
                          revenueBloc.setTimeSelected(
                              DateTime.now().add(Duration(hours: 24 * index)));
                        },
                        child: buildDateItem(
                            context: context,
                            selected: revenueBloc.indexDateTime == index
                                ? true
                                : false,
                            dataTime: DateTime.now()
                                .add(Duration(hours: 24 * index))),
                      );
                    }),
              ),
              SizedBox(height: 15),
              DropDown(),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text("Số người đặt",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  trailing: Text(
                    revenueBloc.loadingLoadingRevenue
                        ? "..."
                        : revenueBloc.listBook.length.toString(),
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ),
              revenueBloc.loadingLoadingRevenue
                  ? listRevenue(context, revenueBloc.listBook, true)
                  : listRevenue(context, revenueBloc.listBook, false),
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
                    child: Text(dataTime.weekday ==7?"Chủ Nhật " :"Thứ " + (dataTime.weekday+1).toString(),
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

class DropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RevenueBloc revenueBloc = Provider.of<RevenueBloc>(context);

    if (revenueBloc.loadingTypeYardAndYard == true) {
      return Container(
        height: 75,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
        padding: const EdgeInsets.only(top: 5, right: 10, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            DropDownTypeYard(),
            DropDownYard(),
          ],
        ));
  }
}

Widget listRevenue
    (BuildContext context, List<BookTime> listBook, bool isLoading) {
  RevenueBloc revenueBloc = Provider.of<RevenueBloc>(context);
  double amount = 0;
  double sumMinute = 0;

  if (listBook == null) {
    listBook = [];
  }

  if(revenueBloc.nullTypeYard) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.accessibility_new,color: Colors.green,size: 30,),
                SizedBox(height: 10,),
                Text("Chưa có sân",style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 17,
                    color: Colors.redAccent
                ),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Hãy thêm sân ở phần thiết lập", style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 17,
                    color: Colors.black54
                  ),),
                )

              ],
            ),
        ],
      ),

    );
  }

  listBook.forEach((itemBook) {
    DateTime dateTime2 = new DateTime.fromMillisecondsSinceEpoch(itemBook.timeStop);
    DateTime dateTime1 = new DateTime.fromMillisecondsSinceEpoch(itemBook.timeStart);
    amount += itemBook.money;
    sumMinute +=((dateTime2.hour*60+dateTime2.minute) - (dateTime1.hour*60+dateTime1.minute));
  });

  FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
      amount: amount
  );

  if (isLoading) {
    return Expanded(
        child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                LinearProgressIndicator()
              ],
            )));
  }

  return Expanded(
      child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("Tổng giờ đá",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  trailing: Text(
                   sumMinute<60 ? (sumMinute~/1).toString() + " phút" : (sumMinute~/60).toString() + " giờ" + " " + ((sumMinute - (sumMinute~/60)*60)~/1).toString() + " phút"

                    ,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
                ListTile(
                  title: Text("Doanh thu",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  trailing: Text(fmf.output.withoutFractionDigits + "đ",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
                Center(
                  child: SahaButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => DetailRevenue(
                          yardName: revenueBloc.yardName,
                          listBook: revenueBloc.listBook,
                        )
                      ));
                    },
                    child: Text("Chi tiết", style: TextStyle(
                      color: Colors.white
                    ),),
                  ),
                )
              ],
            ),
          ),
  ));
}

// ignore: must_be_immutable
class DropDownTypeYard extends StatelessWidget {
  var listDropType = new List<DropdownMenuItem<int>>();

  @override
  Widget build(BuildContext context) {
    RevenueBloc revenueBloc = Provider.of<RevenueBloc>(context);

    if (revenueBloc.typeYardAndYard["data"].length > 0) {
      listDropType.clear();

      int i = 0;
      revenueBloc.typeYardAndYard["data"].forEach((key, value) {
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
            revenueBloc.setIndexYard(0);
            revenueBloc.setIndexTypeYard(index);
            revenueBloc.getYardOfUser(
                revenueBloc.typeYardAndYard["data"].keys.toList()[index]);
          },
          hint: Text(
            'Chọn sân',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          value: revenueBloc.indexTypeYard,
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
    RevenueBloc revenueBloc = Provider.of<RevenueBloc>(context);

    if (revenueBloc.yards != null ||
        revenueBloc.yards.length != null ||
        revenueBloc.yards.length > 0) {
      listDropYard.clear();

      int i = 0;
      for (prefix0.Yard itemYard in revenueBloc.yards) {
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
            revenueBloc.setIndexYard(value);
          },
          hint: Text(
            'Chọn sân',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          value: revenueBloc.indexYard,
        ),
      ),
    );
  }
}
