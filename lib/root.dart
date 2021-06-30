import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'datamigration.dart';
import 'db.dart';
import 'ring.dart';
import 'editTime.dart';
import 'testshow.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';


class RootWidget extends StatefulWidget {


  RootWidget({Key key}) : super(key: key);

  @override
  _RootWidgetState createState() => _RootWidgetState();
}


const platform = const MethodChannel('samples.flutter.dev/runAlarm');

Future<void> _runAlarm(String alarmTime) async {
  String resultStr;
  try {
    final int result = await platform.invokeMethod(alarmTime);
    resultStr = 'Battery level at $result % .';
  } on PlatformException catch (e) {
    resultStr = "Failed to get battery level: '${e.message}'.";
  }
}


class _RootWidgetState extends State<RootWidget>  with WidgetsBindingObserver{
  var _textController = TextEditingController();

  final Color headcolor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.paused) {

    } else if (state == AppLifecycleState.resumed) {

      //setState(_handleOnResumed);

    }
  }

  void _handleOnResumed() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TestshowWidget()),
    ).then((value) => setState(() {}));
  }
  @override
  Widget build(BuildContext context) {

    alarmStart();
    //_runAlarm();

    AlarmList al = AlarmList();


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.home_sharp),
        title: Text('TODO 修正する'),
        backgroundColor: headcolor,
        actions: [
          IconButton(
            icon: Icon(Icons.adb_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TestshowWidget()),
              ).then((value) => setState(() {}));

            },
          ),
          IconButton(
            icon: Icon(Icons.access_alarm),
            onPressed: () {
              _textController.text = '';
              showDialog(
                context: context,
                builder: (BuildContext context) => new AlertDialog(
                  title: new Text("アラームセット"),
                  content: Container(
                      height: 50, child: Text("アラームセットしてもよろしいですか？")),
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
                          alarmStart();
                          Navigator.pop(context, _DialogActionType.ok);
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

    print("あああnextTime"+nextTime.toString());
    print("now:"+DateTime.now().toString());
    if (nextTime == null) {
    } else {
      //AndroidAlarmManager.oneShotAt(nextTime, alarmHeaderList[i].id, fireAlarm);
      print("セット処理");
      print("時間inMilliseconds:"+nextTime.difference(DateTime.now()).inMilliseconds.toString());
      print("時間inHours:"+nextTime.difference(DateTime.now()).inHours.toString());
      print("時間inMinute:"+nextTime.difference(DateTime.now()).inMinutes.toString());
      print("時間inseconds:"+nextTime.difference(DateTime.now()).inSeconds.toString());
      _runAlarm(nextTime.difference(DateTime.now()).inMilliseconds.toString());
    }
  }
}

Future<DateTime> calcNext(int alarmHeaderId, MyDatabase db) async {
  DateTime initialDayNow;
  DateTime targetDayNow;
  bool targetWeekdayValid;

  List<AlarmHeader> ah = await db.selectAlarmHeaderById(alarmHeaderId);
  if (ah[0].valid == false) {
    return null;
  }

  var now = DateTime.now();
  if(now.isBefore(DateTime(now.year,now.month,now.day,ah[0].time.hour,ah[0].time.minute,0,0))) {
    initialDayNow=now;
  }else{
    initialDayNow=now.add(Duration(days:1));
  }
print("最初のinitialDayNow"+initialDayNow.toString());
  for (int i = 0; i < 7; i++) {

    targetDayNow=initialDayNow.add(Duration(days:i));

    print("targetDayNow"+i.toString()+"時間は"+targetDayNow.toString());
    if (targetDayNow.weekday == 1) {
      targetWeekdayValid = ah[0].mondayValid;
    } else if (targetDayNow.weekday == 2) {
      targetWeekdayValid = ah[0].tuesdayValid;
    } else if (targetDayNow.weekday == 3) {
      targetWeekdayValid = ah[0].wednesdayValid;
    } else if (targetDayNow.weekday == 4) {
      targetWeekdayValid = ah[0].thursdayValid;
    } else if (targetDayNow.weekday == 5) {
      targetWeekdayValid = ah[0].fridayValid;
    } else if (targetDayNow.weekday == 6) {
      targetWeekdayValid = ah[0].saturdayValid;
    } else {
      targetWeekdayValid = ah[0].sundayValid;
    }

    print("targetWeekdayValid"+targetWeekdayValid.toString());
    if (targetWeekdayValid) {
      return(DateTime(targetDayNow.year,targetDayNow.month,targetDayNow.day,ah[0].time.hour,ah[0].time.minute,0,0));
    }
  }
  return null;
}

void fireAlarm() {
  print('Alarm Fired at ${DateTime.now()}');

}

