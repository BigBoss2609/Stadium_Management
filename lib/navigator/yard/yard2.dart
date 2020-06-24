import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saha_owner/component/dialog/saha_dialog_yes_no.dart';
import 'add_yard_modal.dart';
import 'yard_bloc.dart';

class Yard extends StatefulWidget {
  @override
  _YardState createState() => _YardState();
}

class _YardState extends State<Yard> {
  var context;

  @override
  Widget build(BuildContext context) {
    context = context;
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: onPressAddYard,
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF0C428F),
          automaticallyImplyLeading: false,
          title: Text("Thiết lập sân"),
          actions: <Widget>[
            IconButton(
              onPressed: onPressAddYard,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Body());
  }

  void showModalEdit() {
    showDialog(
        context: context,
        builder: (BuildContext context) => SahaDiaLogYesNo(
            title: "Xác nhận", content: "Bạn đồng ý xóa sân này!"));
  }

  void showDialogRemove() {
    showDialog(
        context: context,
        builder: (BuildContext context) => SahaDiaLogYesNo(
            title: "Xác nhận", content: "Bạn đồng ý xóa sân này!"));
  }



  void onPressAddYard() {
    YardBloc yardBloc = Provider.of<YardBloc>(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddYardModal(
            onAdd: (yard) {
              yardBloc.addYard(
                  yard: yard,
                  success: () {
                    Navigator.of(context).maybePop();
                    yardBloc.getYardOfUser(yard.typeYard.value);
                  },
                  failed: (err) {
                    print(err.toString());
                  });
            },
          );
        });
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            builder: (_) => YardBloc(),
          )
        ],
        child: Container(
            color: Color(0xFFDFE9F7),
            child: Column(
              children: <Widget>[ ],
            )));
  }
}

//class listTypeYard extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    Widget listTypeYard() {
//
//      YardBloc yardBloc = Provider.of<YardBloc>(context);
//
//      return StreamBuilder<dynamic>(
//          stream: yardBloc.streamTypeYards,
//          builder: (context, snapshot) {
//            if (!snapshot.hasData)
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            if (snapshot.data["status"] == false)
//              return Center(
//                child: Text(snapshot.data["mess"]),
//              );
//            if (snapshot.data["data"].length == 0)
//              return Center(
//                child: Text("Khong co san nao"),
//              );
//            return Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: SizedBox(
//                  height: 70,
//                  child: ListView.builder(
//                    scrollDirection: Axis.horizontal,
//                    itemCount: snapshot.data.length,
//                    itemBuilder: (context, index) => Padding(
//                      padding: const EdgeInsets.all(2),
//                      child: StreamBuilder<Object>(
//                          stream: yardBloc.streamIndexTypeYard,
//                          builder: (context, snapshotIndex) {
//                            yardBloc.getYardOfUser(
//                                snapshot.data[snapshotIndex.data].name);
//
//                            return Container(
//                              height: 70,
//                              width: 70,
//                              decoration: BoxDecoration(
//                                  color: snapshotIndex.data == index
//                                      ? Colors.blue
//                                      : Colors.white,
//                                  shape: BoxShape.rectangle,
//                                  borderRadius:
//                                  BorderRadius.all(Radius.circular(10))),
//                              child: MaterialButton(
//                                onPressed: () {
//                                  yardBloc.setIndexType(index);
//                                },
//                                child: Column(
//                                  mainAxisAlignment:
//                                  MainAxisAlignment.spaceAround,
//                                  children: <Widget>[
//                                    Text(
//                                      "Sân",
//                                      style: TextStyle(
//                                          fontSize: 18,
//                                          color: snapshotIndex.data == index
//                                              ? Colors.white
//                                              : Colors.blue,
//                                          fontWeight: FontWeight.w300),
//                                    ),
//                                    Text(snapshot.data[index].name,
//                                        style: TextStyle(
//                                            fontSize: 17,
//                                            color: snapshotIndex.data == index
//                                                ? Colors.white
//                                                : Colors.grey)),
//                                  ],
//                                ),
//                              ),
//                            );
//                          }),
//                    ),
//                  ),
//                ));
//          });
//    }
//  }
//}
