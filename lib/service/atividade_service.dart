import 'dart:async';

import 'package:catolica/db/DBHelper.dart';
import 'package:catolica/domain/atividade.dart';
import 'package:catolica/stores/atividade_store.dart';
import 'package:sqflite/sqflite.dart';

class AtividadeService {
  final AtividadeStore atividadeStore;
  final DbHelper dbHelper;

  AtividadeService(this.atividadeStore, this.dbHelper);

  Future<List<Atividade>> carregarAtividades() async {
    return dbHelper.getDatabase().then((db) {
      return db.query(Atividade.TABLE_NAME)
          .then((atividadesMap) => atividadesMap.map((map) => Atividade.fromMap(map)).toList())
          .then((atividades) {
            atividadeStore.setAtividades(atividades);
            return atividades;
      });
    });
  }

  Future<Atividade> salvar(Atividade atividade) async {
    final Database db = await dbHelper.getDatabase();

    int idAtividade = await db.insert(
      Atividade.TABLE_NAME,
      atividade.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    atividadeStore.adicionarAtividade(atividade.copyWith(id: idAtividade));
    return Future.value(atividade);
  }

  void dispose() {}
}
