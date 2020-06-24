import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saha_owner/navigator/yard/yard_bloc.dart';

class Yard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        builder: (context) => YardBloc(),
      )
    ], child: BodyYard());
  }
}

class BodyYard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    YardBloc yardBloc = Provider.of<YardBloc>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEDFE9F7),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          yardBloc.onPressAddYard(context);
        },
        child: Icon(Icons.add),
      ),
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
                    padding: const EdgeInsets.only(top: 70, left: 30),
                    child: Text(
                      "Thiết lập sân",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              ListTypeYard(),
              ListYard(),
            ],
          ),
        ],
      ),
    );
  }
}

class ListTypeYard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    YardBloc yardBloc = Provider.of<YardBloc>(context);
    if (yardBloc.loadingTypeYards)
      return Center(
        child: LinearProgressIndicator(),
      );

    return StreamBuilder<dynamic>(
        stream: yardBloc.streamTypeYards,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data["status"] == false)
            return Center(
              child: Text(snapshot.data["mess"]),
            );
          if (snapshot.data == null || snapshot.data["data"].length == 0)
            return Container(
              height: 70,
              child: Center(
                child: Text(
                  "Hãy thêm sân để quản lý",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            );
          return Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data["data"].length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                          color: yardBloc.indexTypeYard == index
                              ? Colors.green
                              : Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: MaterialButton(
                        onPressed: () {
                          yardBloc.setIndexType(index);
                          yardBloc
                              .getYardOfUser(snapshot.data["data"][index].name);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              "Sân",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: yardBloc.indexTypeYard == index
                                      ? Colors.white
                                      : Colors.blue,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(snapshot.data["data"][index].name,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: yardBloc.indexTypeYard == index
                                        ? Colors.white
                                        : Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}

class ListYard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    YardBloc yardBloc = Provider.of<YardBloc>(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: yardBloc.loadingYards
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder<dynamic>(
                  stream: yardBloc.streamYards,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    if (snapshot.data["data"].length == 0)
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.accessibility_new,
                              color: Colors.green,
                              size: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Chưa có sân",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17),
                            ),
                          ],
                        ),
                      );

                    return ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data["data"].length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) => ListTile(
                            title: Text(snapshot.data["data"][index].name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  color: Colors.lightGreen,
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    yardBloc.showModalEdit(
                                        context, snapshot.data["data"][index]);
                                  },
                                ),
                                IconButton(
                                  color: Colors.red,
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    yardBloc.showDialogRemove(
                                        context, snapshot.data["data"][index]);
                                  },
                                )
                              ],
                            )));
                  }),
        ),
      ),
    );
  }
}
