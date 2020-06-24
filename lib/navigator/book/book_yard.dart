import 'package:flutter/material.dart';
import 'package:html/dom.dart' as prefix1;
import 'package:infinite_listview/infinite_listview.dart';
import 'package:provider/provider.dart';
import 'package:saha_owner/navigator/book/book_yard_bloc.dart';
import 'package:saha_owner/object/book_time.dart';
import 'package:saha_owner/object/yard.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';
import 'add_book.dart';
import 'day_view.dart';

class BookYard extends StatelessWidget {
  final double openTime;
  final double closeTime;

  const BookYard({Key key, this.openTime=5, this.closeTime=22}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => BookYardBloc(),
        )
      ],
      child: BookYardBody(openTime, closeTime),
    );
  }
}

// ignore: must_be_immutable
class BookYardBody extends StatelessWidget {
  BuildContext contextMain;
   double openTime;
   double closeTime;

  BookYardBody(this.openTime, this.closeTime);

  @override
  Widget build(BuildContext context) {

    BookYardBloc bookYardBloc = Provider.of<BookYardBloc>(context);
    bookYardBloc.hourStart = openTime~/1;
    bookYardBloc.hourStop = closeTime~/1;
    contextMain = context;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor:
            bookYardBloc.nullTypeYard || bookYardBloc.loadingLoadingBookYard ? Colors.grey : Colors.green,
        onPressed: bookYardBloc.nullTypeYard || bookYardBloc.loadingLoadingBookYard
            ? null
            : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddBookYard(
                              bookYardBloc: bookYardBloc,
                            ))).then((value) {
                  if (value != null && value) {
                    bookYardBloc.getBookTimes();
                  }
                });
              },
      ),
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
                          bookYardBloc.setIndexDateTime(index);
                          bookYardBloc.setTimeSelected(
                              DateTime.now().add(Duration(hours: 24 * index)));
                        },
                        child: buildDateItem(
                            context: context,
                            selected: bookYardBloc.indexDateTime == index
                                ? true
                                : false,
                            dataTime: DateTime.now()
                                .add(Duration(hours: 24 * index))),
                      );
                    }),
              ),
              SizedBox(height: 15),
              DropDown(),
              bookYardBloc.nullTypeYard ?
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Center(child: Text("Chưa có sân hãy thêm sân ở phần thiết lập",style: TextStyle(
                      color: Colors.green,
                      fontSize: 17
                    ),)),
                  )
                  : Container(
                color: Colors.white,
                child: ListTile(

                  title: Text("Số người đặt",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  trailing: Text(
                    bookYardBloc.loadingLoadingBookYard
                        ? "..."
                        : bookYardBloc.listBook.length.toString(),
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ),
              bookYardBloc.loadingLoadingBookYard
                  ? listBookYard(context, bookYardBloc.listBook, true, openTime, closeTime)
                  : listBookYard(context, bookYardBloc.listBook, false, openTime, closeTime),
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
    BookYardBloc bookYardBloc = Provider.of<BookYardBloc>(context);

    if (bookYardBloc.loadingTypeYardAndYard == true) {
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

Widget listBookYard
    (BuildContext context, List<BookTime> listBook, bool isLoading, double openTime, double closeTime) {

  BookYardBloc bookYardBloc = Provider.of<BookYardBloc>(context);

  if (listBook == null) {
    listBook = [];
  }

  if (isLoading) {
    return Expanded(
        child: Container(
            color: Colors.white,
            child: DayView(
              hourStart: openTime,
              hourStop: closeTime,
              contextMain: context,
              listBookTime: null,
              isLoading: true,

            )));
  }

  return Expanded(
      child: Container(
          color: Colors.white,
          child: DayView(
              hourStart: openTime,
              hourStop: closeTime,
            contextMain: context,
            listBookTime: listBook,
            isLoading: false,
              onChange: (value) {
              Navigator.maybePop(context);
                if(value != null && value) bookYardBloc.getBookTimes();
              }
          )));
}

// ignore: must_be_immutable
class DropDownTypeYard extends StatelessWidget {
  var listDropType = new List<DropdownMenuItem<int>>();

  @override
  Widget build(BuildContext context) {
    BookYardBloc bookYardBloc = Provider.of<BookYardBloc>(context);

    if (bookYardBloc.typeYardAndYard["data"].length > 0) {
      listDropType.clear();

      int i = 0;
      bookYardBloc.typeYardAndYard["data"].forEach((key, value) {
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
            bookYardBloc.setIndexYard(0);
            bookYardBloc.setIndexTypeYard(index);
            bookYardBloc.getYardOfUser(
                bookYardBloc.typeYardAndYard["data"].keys.toList()[index]);
          },
          hint: Text(
            'Chọn sân',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          value: bookYardBloc.indexTypeYard,
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
    BookYardBloc bookYardBloc = Provider.of<BookYardBloc>(context);

    if (bookYardBloc.yards != null ||
        bookYardBloc.yards.length != null ||
        bookYardBloc.yards.length > 0) {
      listDropYard.clear();

      int i = 0;
      for (prefix0.Yard itemYard in bookYardBloc.yards) {
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
            bookYardBloc.setIndexYard(value);
          },
          hint: Text(
            'Chọn sân',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          value: bookYardBloc.indexYard,
        ),
      ),
    );
  }
}
