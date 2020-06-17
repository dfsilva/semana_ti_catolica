import 'dart:async';

import 'package:catolica/db/DBHelper.dart';
import 'package:catolica/domain/atividade.dart';
import 'package:catolica/stores/atividade_store.dart';
import 'package:catolica/stores/hud_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadeService {
  final AtividadeStore atividadeStore;
  final DbHelper dbHelper;
  final Firestore _firestore;
  final HudStore _hudStore;

  AtividadeService(this.atividadeStore, this.dbHelper, this._firestore, this._hudStore);

  Future<List<Atividade>> carregarAtividades() async {
//    return dbHelper.getDatabase().then((db) {
//      return db.query(Atividade.TABLE_NAME)
//          .then((atividadesMap) => atividadesMap.map((map) => Atividade.fromMap(map)).toList())
//          .then((atividades) {
//            atividadeStore.setAtividades(atividades);
//            return atividades;
//      });
//    });

//    this._hudStore.show("Carregando atividades...");
    return _firestore
        .collection(Atividade.TABLE_NAME)
        .getDocuments()
        .then((qsnp) => qsnp.documents.map((document) => Atividade.fromMap(document.data)).toList());
//        .whenComplete(() => this._hudStore.hide());
  }

  Future<Atividade> salvar(Atividade atividade) async {
//    final Database db = await dbHelper.getDatabase();

//    int idAtividade = await db.insert(
//      Atividade.TABLE_NAME,
//      atividade.toMap(),
//      conflictAlgorithm: ConflictAlgorithm.replace,
//    );

    DocumentReference atividadeRef = _firestore.collection(Atividade.TABLE_NAME).document();
    Atividade novaAtividade = atividade.copyWith(id: atividadeRef.documentID);
    atividadeStore.adicionarAtividade(novaAtividade);

    return atividadeRef.setData(novaAtividade.toMap()).then((_) => novaAtividade);
  }

  void dispose() {}
}
