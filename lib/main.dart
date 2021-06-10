import 'package:alarm2/db.dart';
import 'package:alarm2/root.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

void main() async {
  runApp(MyApp());
  await AndroidAlarmManager.initialize();
  alarmStart();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      home: RootWidget(),
    );
  }
}

void alarmStart() async {
  MyDatabase db = MyDatabase();
  List<AlarmHeader> alarmHeaderList =
      await MyDatabase().selectAlarmHeaderOrderByTime();

  for (int i = 0; i < alarmHeaderList.length; i++) {
    DateTime nextTime = await calcNext(alarmHeaderList[i].id, db);

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
          now.isBefore(DateTime(now.year,now.month,now.day,ah[0].time.hour,ah[0].time.minute,now.second,now.millisecond))) {
        return(DateTime(now.year,now.month,now.day,ah[0].time.hour,ah[0].time.minute,now.second,now.millisecond).add(Duration(days:i)));

      }else{

      }
    }
  }
  return null;
}

void fireAlarm() {
  print('Alarm Fired at ${DateTime.now()}');
}
