import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TimeDuration extends StatelessWidget {
  
  int timeStart;
  int timeStop ;

  TimeDuration({this.timeStart=0, this.timeStop=0});

  @override
  Widget build(BuildContext context) {
    int timeSpace = timeStop - timeStart;
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildTime(timeStart,true),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Icon(Icons.arrow_forward),
              ),
              buildTime(timeStop,false),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: <Widget>[
              Text("Tổng thời gian", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: timeSpace < 0
                    ? Text("...")
                    : timeSpace < 3600
                        ? Text(
                            ((timeSpace - ((timeSpace ~/ 3600) * 3600)) ~/ 60)
                                    .toString()
                                    .padLeft(2, "0") +
                                " phút",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        : Text(
                            (timeSpace ~/ 3600).toString().padLeft(2, "0") +
                                " giờ " +
                                ((timeSpace - ((timeSpace ~/ 3600) * 3600)) ~/ 60)
                                    .toString()
                                    .padLeft(2, "0") +
                                " phút",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildTime(int time, bool type) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(type ? "Bắt đầu" : "Kết thúc", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300)),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text(
            (time ~/ 3600).toString().padLeft(2, "0") +
                ":" +
                ((time - ((time ~/ 3600) * 3600)) ~/ 60).toString().padLeft(2, "0"),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

 
}
