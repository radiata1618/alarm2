import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'datamigration.dart';
import 'db.dart';
import 'ring.dart';
import 'editTime.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

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

    alarmStart();

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
                      height: 50, child: Text("をリセットしてもよろしいですか？")),
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


void alarmStart() async {
  print("アラームセット3");
  MyDatabase db = MyDatabase();
  List<AlarmHeader> alarmHeaderList =
  await MyDatabase().selectAlarmHeaderOrderByTime();

  for (int i = 0; i < alarmHeaderList.length; i++) {
    DateTime nextTime = await calcNext(alarmHeaderList[i].id, db);

    print("nextTime"+nextTime.toString());
    if (nextTime == null) {
    } else {
      AndroidAlarmManager.oneShotAt(nextTime, alarmHeaderList[i].id, fireAlarm);
    }
  }
}

Future<DateTime> calcNext(int alarmHeaderId, MyDatabase db) async {
  int targetWeekday;
  bool targetWeekdayValid;

  List<AlarmHeader> ah = await db.selectAlarmHeaderById(alarmHeaderId);
  if (ah[0].valid == false) {
    return null;
  }

  var now = DateTime.now();
  targetWeekday = now.weekday;

  for (int i = 0; i < 8; i++) {
    if (targetWeekday == 1) {
      targetWeekdayValid = ah[0].mondayValid;
    } else if (targetWeekday == 2) {
      targetWeekdayValid = ah[0].tuesdayValid;
    } else if (targetWeekday == 3) {
      targetWeekdayValid = ah[0].wednesdayValid;
    } else if (targetWeekday == 4) {
      targetWeekdayValid = ah[0].thursdayValid;
    } else if (targetWeekday == 5) {
      targetWeekdayValid = ah[0].fridayValid;
    } else if (targetWeekday == 6) {
      targetWeekdayValid = ah[0].saturdayValid;
    } else {
      targetWeekdayValid = ah[0].sundayValid;
    }

    if (targetWeekdayValid) {
      if (i != 0 ||
          now.isBefore(DateTime(now.year,now.month,now.day,ah[0].time.hour,ah[0].time.minute,0,0))) {
        return(DateTime(now.year,now.month,now.day,ah[0].time.hour,ah[0].time.minute,0,0).add(Duration(days:i)));

      }else{

      }
    }
  }
  return null;
}

void fireAlarm() {
  print('Alarm Fired at ${DateTime.now()}');

}

