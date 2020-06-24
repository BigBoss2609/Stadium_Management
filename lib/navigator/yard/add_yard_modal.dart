  import 'package:flutter/material.dart';
import 'package:saha_owner/component/text_field/saha_text_field.dart';
import 'package:saha_owner/navigator/yard/add_yard_modal_bloc.dart';
import 'package:saha_owner/object/type_yard.dart';
import 'package:saha_owner/object/yard.dart';

// ignore: must_be_immutable
class AddYardModal extends StatefulWidget {
  Function(Yard) onAdd;
  BuildContext context;

  AddYardModal({this.context, this.onAdd});

  @override
  _AddYardModalState createState() => _AddYardModalState();
}

class _AddYardModalState extends State<AddYardModal> {
  int _currValue = -1;
  TextEditingController textEditingControllerName = new TextEditingController();

  AddYardModalBloc addYardModalBloc = new AddYardModalBloc();

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return AlertDialog(
      title: new Text("Thêm sân"),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SahaTextField(
                controller: textEditingControllerName,
                labelText: "Tên sân",
              ),
              typeYards(),
              StreamBuilder<Object>(
                  stream: addYardModalBloc.streamCheck,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Text(
                            snapshot.data,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w300,
                                fontSize: 17),
                          )
                        : Container();
                  })
            ],
          ),
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
            child: new Text("Thêm"),
            onPressed: () {
              if (_currValue == -1) {
                addYardModalBloc.setCheckTypeYard();
              } else {
                Yard yard = new Yard(
                    typeYard: TypeYard.listTypeYardLocal()[_currValue],
                    name: textEditingControllerName.text);

                addYardModalBloc.onAddYard(
                    yard: yard,
                    checkOK: () {
                      widget.onAdd(yard);
                    });
              }
            }),
        new FlatButton(
          child: new Text("Thoát"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget typeYards() {
    TypeYard.listTypeYardLocal();
    var widgetTypeYards = <Widget>[];

    for (int indexType = 0;
        indexType < TypeYard.listTypeYardLocal().length;
        indexType++) {
      widgetTypeYards.add(Row(
        children: <Widget>[
          Radio(
            groupValue: _currValue,
            onChanged: (int indexTypeLocal) =>
                setState(() => _currValue = indexTypeLocal),
            value: indexType,
          ),
          Text(TypeYard.listTypeYardLocal()[indexType].name)
        ],
      ));
    }

    return Wrap(direction: Axis.horizontal, children: widgetTypeYards);
  }
}
