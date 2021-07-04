import 'package:moor_flutter/moor_flutter.dart';

part 'db.g.dart'; //generated when execute "flutter packages pub run build_runner watch" in terminal

class Parameters extends Table {
  TextColumn get code => text()();

  IntColumn get numberValue => integer().nullable()();

  TextColumn get textValue => text().nullable()();

  DateTimeColumn get timeValue => dateTime().nullable()();

  BoolColumn get booleanValue => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {code};
}

class AlarmHeaders extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get time => dateTime()();

  BoolColumn get valid => boolean()();

  BoolColumn get mondayValid => boolean()();

  BoolColumn get tuesdayValid => boolean()();

  BoolColumn get wednesdayValid => boolean()();

  BoolColumn get thursdayValid => boolean()();

  BoolColumn get fridayValid => boolean()();

  BoolColumn get saturdayValid => boolean()();

  BoolColumn get sundayValid => boolean()();

  IntColumn get walkTime => integer()();

  TextColumn get audioPath => text()();

  TextColumn get audioName => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseMoor(tables: [Parameters, AlarmHeaders])
class MyDatabase extends _$MyDatabase {
  MyDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  MyDatabase db;

  //@override
  MigrationStrategy get migration => destructiveFallback;

  @override
  int get schemaVersion => 5;

  Future<List<Parameter>> getAllparameters() => select(parameters).get();

  Stream<List<Parameter>> watchAllparameters() => select(parameters).watch();

  Future insertparameter(Parameter parameter) =>
      into(parameters).insert(parameter);

  Future updateparameter(Parameter parameter) =>
      update(parameters).replace(parameter);

  Future deleteparameter(Parameter parameter) =>
      delete(parameters).delete(parameter);

  Future<List<AlarmHeader>> getAllalarmheaders() => select(alarmHeaders).get();

  Stream<List<AlarmHeader>> watchAllalarmheaders() =>
      select(alarmHeaders).watch();

  Future insertalarmheader(AlarmHeader alarmheader) =>
      into(alarmHeaders).insert(alarmheader);

  Future updatealarmheader(AlarmHeader alarmheader) =>
      update(alarmHeaders).replace(alarmheader);

  Future deletealarmheader(AlarmHeader alarmheader) =>
      delete(alarmHeaders).delete(alarmheader);


  Future<List<AlarmHeader>> selectAlarmHeaderById(int id) {
    return customSelect(
      'SELECT *' + 'From alarm_Headers ' + 'WHERE id = ?;',
      variables: [Variable.withInt(id)],
      readsFrom: {alarmHeaders},
    )
        .map((row) => AlarmHeader(
        id: row.readInt('id'),
        time: row.readDateTime('time'),
        valid: row.readBool('valid'),
        mondayValid: row.readBool('monday_valid'),
        tuesdayValid: row.readBool('tuesday_valid'),
        wednesdayValid: row.readBool('wednesday_valid'),
        thursdayValid: row.readBool('thursday_valid'),
        fridayValid: row.readBool('friday_valid'),
        saturdayValid: row.readBool('saturday_valid'),
        sundayValid: row.readBool('sunday_valid'),
        walkTime: row.readInt('walk_time'),
        audioPath: row.readString('audio_path'),
        audioName: row.readString('audio_name')))
        .get();
  }

  Future<List<Parameter>> selectParameterByCode(String code) {
    return customSelect(
      'SELECT *' + 'From parameters ' + 'WHERE code = ?;',
      variables: [Variable.withString(code)],
      readsFrom: {parameters},
    )
        .map((row) => Parameter(
            code: row.readString('code'),
        numberValue: row.readInt('number_value'),
        textValue: row.readString('text_value'),
        timeValue: row.readDateTime('time_value'),
        booleanValue: row.readBool('boolean_value')))
        .get();
  }



  Stream<List<AlarmHeader>> selectAlarmHeaderOrderByTimeWatch() {
    return customSelect(
      'SELECT *' + 'From alarm_Headers ' + 'ORDER BY time ASC;',
      readsFrom: {alarmHeaders},
    )
        .map((row) => AlarmHeader(
            id: row.readInt('id'),
            time: row.readDateTime('time'),
            valid: row.readBool('valid'),
            mondayValid: row.readBool('monday_valid'),
            tuesdayValid: row.readBool('tuesday_valid'),
            wednesdayValid: row.readBool('wednesday_valid'),
            thursdayValid: row.readBool('thursday_valid'),
            fridayValid: row.readBool('friday_valid'),
            saturdayValid: row.readBool('saturday_valid'),
            sundayValid: row.readBool('sunday_valid'),
            walkTime: row.readInt('walk_time'),
            audioPath: row.readString('audio_path'),
            audioName: row.readString('audio_name')))
        .watch();
  }

  Future<List<AlarmHeader>> selectAlarmHeaderOrderByTime() {
    return customSelect(
      'SELECT *' + 'From alarm_Headers ' + 'ORDER BY time ASC;',
      readsFrom: {alarmHeaders},
    )
        .map((row) => AlarmHeader(
            id: row.readInt('id'),
            time: row.readDateTime('time'),
            valid: row.readBool('valid'),
            mondayValid: row.readBool('monday_valid'),
            tuesdayValid: row.readBool('tuesday_valid'),
            wednesdayValid: row.readBool('wednesday_valid'),
            thursdayValid: row.readBool('thursday_valid'),
            fridayValid: row.readBool('friday_valid'),
            saturdayValid: row.readBool('saturday_valid'),
            sundayValid: row.readBool('sunday_valid'),
            walkTime: row.readInt('walk_time'),
            audioPath: row.readString('audio_path'),
            audioName: row.readString('audio_name')))
        .get();
  }
}
