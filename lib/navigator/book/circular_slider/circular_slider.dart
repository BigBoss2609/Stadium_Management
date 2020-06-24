import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:saha_owner/object/book_time.dart';

class CircularSlider extends StatelessWidget {
  final Function(int, int) onChange;
  final List<BookTime> listBook;
  final int hourStart;
  final int hourStop;
  const CircularSlider({Key key, this.onChange, this.listBook, this.hourStart, this.hourStop})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          TimeAvailable(
            hourStart: hourStart,
            hourStop: hourStop,
            listBook: listBook,
          ),
          ClockSelect(onChange: onChange)
        ],
      ),
    );
  }
}

class ClockSelect extends StatelessWidget {
  final Function(int, int) onChange;

  const ClockSelect({Key key, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: DoubleCircularSlider(
          288,
          130,
          160,
          height: 245,
          width: 245,
          primarySectors: 4,
          secondarySectors: 24,
          baseColor: Color.fromRGBO(255, 255, 255, 0.1),
          selectionColor: Color.fromRGBO(255, 252, 255, 0.6),
          handlerColor: Colors.white70,
          handlerOutterRadius: 12.0,
          onSelectionChange: (start, end, ba) {
            onChange(start * 60 * 5, end * 60 * 5);
            },
          sliderStrokeWidth: 15.0,
          child: Center(
              child: Container(
                height: 190,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle),
                child: Image.asset("images/clock.png"),
              )),
        ));
  }
}

// ignore: must_be_immutable
class TimeAvailable extends StatelessWidget {
  Key _chartKey = new Key("ghf");
  final List<BookTime> listBook;
  final int hourStart;
  final int hourStop;
  var circularSegmentEntry = new List<CircularSegmentEntry>();

  TimeAvailable({Key key, this.listBook, this.hourStart=6, this.hourStop=10}) : super(key: key) {
    if (listBook != null) {
      listBook.sort();
    }

    getTimeSpan();
  }

  void getTimeSpan() async {

    int currentTime = 0;

    //Draw time don't allow
    //Draw with minute full 1440
    circularSegmentEntry
        .add(new CircularSegmentEntry(hourStart * 60 + .0, Colors.black));
    currentTime = hourStart * 60;

    if (listBook.length > 0) {
      listBook.forEach((itemBookTime) {
        if (itemBookTime.getMinuteInDayTimeStart() > currentTime) {
          circularSegmentEntry.add(new CircularSegmentEntry(
              itemBookTime.getMinuteInDayTimeStart() - currentTime + .0,
              Colors.grey));
          currentTime = itemBookTime.getMinuteInDayTimeStart();
          circularSegmentEntry.add(new CircularSegmentEntry(
              itemBookTime.getMinuteInDayTimeStop() - currentTime + .0,
              Colors.green));
          currentTime = itemBookTime.getMinuteInDayTimeStop();
        }
      });
    }

    circularSegmentEntry.add(new CircularSegmentEntry(
        hourStop * 60 - currentTime + .0, Colors.grey));

    circularSegmentEntry
        .add(new CircularSegmentEntry((24 - hourStop + .0) * 60, Colors.black));
  }

  // new CircularSegmentEntry(1.0, Colors.grey, rankKey: 'Q1')
  @override
  Widget build(BuildContext context) {
    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(circularSegmentEntry),
    ];
    return AnimatedCircularChart(
      key: _chartKey,
      size: const Size(300.0, 300.0),
      initialChartData: data,
      chartType: CircularChartType.Pie,
    );
  }
}
