import 'package:alarm2/db.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class DataMigrant {

  void dataReset() async {
    MyDatabase db = MyDatabase();


    await initialDataCreate(db);
  }


}

Future<void> initialDataCreate(MyDatabase db) async{


  await deleteAllParameters(db);

  initializeDateFormatting("ja_JP");

  var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");

  var datetimeNow = DateTime.now();

  Parameter pm = Parameter(code :"alreadyTime"
      ,numberValue:null
      ,textValue:formatter.format(datetimeNow)
      ,timeValue:datetimeNow
      ,booleanValue:null);
  db.insertparameter(pm);

}


Future<void> deleteAllParameters(MyDatabase db) async {

  print('deleting');

  List<Parameter> parametersList = await db.getAllparameters();
  for(var parameter in parametersList){
    await db.deleteparameter(parameter);
  }

  print('deleted');
}