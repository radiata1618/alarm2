import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'datamigration.dart';
import 'db.dart';
import 'editTime.dart';


class RootWidget extends StatefulWidget {
  RootWidget({Key key}) : super(key: key);

  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  var _textController = TextEditingController();

  final Color headcolor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    AlarmList al = AlarmList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.home_sharp),
        title: Text(""),
        backgroundColor: headcolor,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _textController.text = '';
              showDialog(
                context: context,
                builder: (BuildContext context) => new AlertDialog(
                  title: new Text("リセット"),
                  content: Container(
                      height: 50, child: Text("学習データをリセットしてもよろしいですか？")),
                  // ボタンの配置
                  actions: <Widget>[
                    new TextButton(
                        child: const Text('キャンセル'),
                        onPressed: () {
                          Navigator.pop(context, _DialogActionType.cancel);
                        }),
                    new TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          DataMigrant dataMigrant = DataMigrant();
                          dataMigrant.dataReset();
                          Navigator.pop(context, _DialogActionType.cancel);
                        })
                  ],
                ),
              ).then<void>((value) {
                // ボタンタップ時の処理
                switch (value) {
                  case _DialogActionType.cancel:
                    print("cancel...");
                    break;
                  case _DialogActionType.ok:
                    print("OK!!");
                    break;
                  default:
                    print("default");
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(child: al),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.close),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditTimeWidget(alarmHeaderId: null)),
          ).then((value) => setState(() {}));
        },
      ),
    );
  }
}

enum _DialogActionType {
  cancel,
  ok,
}

class AlarmList extends StatefulWidget {
  @override
  _AlarmListstate createState() => _AlarmListstate();
}

class _AlarmListstate extends State<AlarmList> {
  TextEditingController productNameController = TextEditingController();

  TextEditingController priceController = TextEditingController();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 700,
          width: double.infinity,
          child: StreamBuilder(
            stream: MyDatabase().selectAlarmHeaderOrderByTimeWatch(),
            builder: (context, AsyncSnapshot<List<AlarmHeader>> snapshot) {
              return snapshot == null
                  ? Container()
                  : ListView.builder(
                itemBuilder: (_, index) {
                  /*if(widget.qhList.length <= index){
                    widget.qhList.add(snapshot.data[index]);
                    widget.checkedList.add(false);
                  }else{
                  }*/
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTimeWidget(
                                alarmHeaderId: snapshot.data[index].id)),
                      ).then((value) => setState(() {}));
                    },
                    child: Card(
                        child: Row(children: [
                          Container(
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.blue),
                                  Text(
                                    DateFormat('HH:mm')
                                        .format(snapshot.data[index].time),
                                  )
                                ],
                              )),
                          Container(
                              child: Checkbox(
                                value: snapshot.data[index].valid,
                                onChanged: (value) {
                                  AlarmHeader ah = AlarmHeader(
                                      id: snapshot.data[index].id,
                                      time: snapshot.data[index].time,
                                      valid: !snapshot.data[index].valid,
                                      mondayValid:
                                      snapshot.data[index].mondayValid,
                                      tuesdayValid:
                                      snapshot.data[index].tuesdayValid,
                                      wednesdayValid:
                                      snapshot.data[index].wednesdayValid,
                                      thursdayValid:
                                      snapshot.data[index].thursdayValid,
                                      fridayValid:
                                      snapshot.data[index].fridayValid,
                                      saturdayValid:
                                      snapshot.data[index].saturdayValid,
                                      sundayValid:
                                      snapshot.data[index].sundayValid,
                                      walkTime: snapshot.data[index].walkTime,
                                      audioPath: snapshot.data[index].audioPath,
                                      audioName: snapshot.data[index].audioName);

                                  MyDatabase().updatealarmheader(ah);
                                  setState(
                                          () => value = !snapshot.data[index].valid);
                                },
                              )),
                          IconButton(
                            iconSize: 25,
                            onPressed: () {
                              setState(() {
                                MyDatabase()
                                    .deletealarmheader(snapshot.data[index]);
                              });
                            },
                            color: Colors.blue,
                            icon: Icon(Icons.delete),
                          ),
                        ])),
                  );
                },
                itemCount: snapshot.data?.length ?? 0, //null対応済
              );
            },
          ),
        )
      ],
    );
  }
}
