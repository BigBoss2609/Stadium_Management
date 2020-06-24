import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saha_owner/component/button/saha_button_blue.stateless.dart';
import 'package:saha_owner/component/dialog/saha_dialog_error.dart';
import 'package:saha_owner/component/time/time_duration.dart';
import 'package:saha_owner/navigator/book/select_time_modal/select_time_modal_bloc.dart';
import 'package:saha_owner/object/book_time.dart';
import '../circular_slider/circular_slider.dart';

class SelectTimeModal extends StatelessWidget {
  final int hourStart;
  final int hourStop;
  final Function(int, int) onChange;
  final List<BookTime> listBook;
  const SelectTimeModal({Key key, this.onChange, this.listBook, this.hourStart, this.hourStop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            builder: (context) => SelectTimeModalBloc(listBook),
          )
        ],
        child: BodyDialog(
          hourStop: hourStop,
          hourStart: hourStart,
          onChange: onChange,
          listBook: listBook,
        ));
  }
}

class BodyDialog extends StatelessWidget {
  final Function(int, int) onChange;
  final List<BookTime> listBook;
  final int hourStart;
  final int hourStop;
  const BodyDialog({Key key, this.onChange, this.listBook, this.hourStart, this.hourStop}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SelectTimeModalBloc selectTimeModalBloc =
        Provider.of<SelectTimeModalBloc>(context);
    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TimeDuration(
            timeStop: selectTimeModalBloc.end,
            timeStart: selectTimeModalBloc.start,
          ),
          CircularSlider(
            hourStart: hourStart,
            hourStop: hourStop,
            onChange: (start, end) {
              selectTimeModalBloc.setDuration(start, end);
            },
            listBook: listBook,
          ),
          SahaButton(
            onPressed: () {

              if(selectTimeModalBloc.end - selectTimeModalBloc.start < 0)
                {
                  showDialog(context: context, builder: (context) => SahaDiaLogError(title: "Lỗi!", content: "Thời gian không hợp lệ",));

                  return;
                }

              if (hourStart*3600 > selectTimeModalBloc.start || hourStop*3600 < selectTimeModalBloc.end) {
                showDialog(context: context, builder: (context) => SahaDiaLogError(title: "Lỗi!", content: "Thời gian này không phải thời gian mở cửa",));

                return;
              }

             if (selectTimeModalBloc.isCoincideTime()) {
               showDialog(context: context, builder: (context) => SahaDiaLogError(title: "Trùng thời gian!", content: "Thời gian này đã có người đặt xin chọn khung giờ khác",));

               return;
              }
              onChange(selectTimeModalBloc.start, selectTimeModalBloc.end);
              Navigator.maybePop(context);
            },
            child: Text(
              "chọn".toString(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 30,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: Center(
                  child: Text("Không thể đặt",style: TextStyle(
                    fontSize: 12,
                    color: Colors.white
                  ),),
                ),
              ),
              Container(
                height: 30,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: Center(
                  child: Text("Đã được đặt",style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                  ),),
                ),
              ),
              Container(
                height: 30,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: Center(
                  child: Text("Khung giờ trống",style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                  ),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
