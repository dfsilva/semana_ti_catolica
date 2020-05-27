import 'dart:async';

import 'package:catolica/domain/atividade.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database _database;

  Future<Database> getDatabase() async {
    if (_database == null) {
      return openDatabase(
        join(await getDatabasesPath(), 'semana_ti_catolica.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE ${Atividade.TABLE_NAME}(id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "nome TEXT, "
            "descricao TEXT, "
            "local TEXT, "
            "dataHoraInicio INTEGER, "
            "dataHoraFim INTEGER, "
            "foto TEXT, "
            "usuario TEXT "
            ")",
          );
        },
        version: 1,
      ).then((value) {
        this._database = value;
        return value;
      });
    } else {
      return Future.value(_database);
    }
  }
}
