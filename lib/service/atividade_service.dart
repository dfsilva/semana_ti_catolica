import 'dart:async';

import 'package:catolica/db/DBHelper.dart';
import 'package:catolica/domain/atividade.dart';
import 'package:catolica/stores/atividade_store.dart';
import 'package:catolica/stores/hud_store.dart';
import 'package:catolica/stores/usuario_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadeService {
  final AtividadeStore atividadeStore;
  final DbHelper dbHelper;
  final Firestore _firestore;
  final HudStore _hudStore;
  final UsuarioStore _usuarioStore;
  StreamSubscription _atividadesStream;

  AtividadeService(this.atividadeStore, this.dbHelper, this._firestore, this._hudStore, this._usuarioStore) {
    this._atividadesStream = atividadesStream().listen((atividades) {
      atividadeStore.setAtividades(atividades);
    });
  }

  Future<List<Atividade>> carregarAtividades() async {
//    return dbHelper.getDatabase().then((db) {
//      return db.query(Atividade.TABLE_NAME)
//          .then((atividadesMap) => atividadesMap.map((map) => Atividade.fromMap(map)).toList())
//          .then((atividades) {
//            atividadeStore.setAtividades(atividades);
//            return atividades;
//      });
//    });

    return _firestore
        .collection(Atividade.TABLE_NAME)
        .where("usuario", isEqualTo: _usuarioStore.usuario.uid)
        .getDocuments()
        .then((qsnp) => qsnp.documents.map((document) => Atividade.fromMap(document.data)).toList());
  }

  Stream<List<Atividade>> atividadesStream() {
    return _firestore
        .collection(Atividade.TABLE_NAME)
        .where("usuario", isEqualTo: _usuarioStore.usuario.uid)
        .snapshots()
        .map((qsnp) => qsnp.documents.map((document) => Atividade.fromMap(document.data)).toList());
  }

  Future<Atividade> salvar(Atividade atividade) async {
//    final Database db = await dbHelper.getDatabase();

//    int idAtividade = await db.insert(
//      Atividade.TABLE_NAME,
//      atividade.toMap(),
//      conflictAlgorithm: ConflictAlgorithm.replace,
//    );

    _hudStore.show("Salvando atividade...");
    DocumentReference atividadeRef = _firestore.collection(Atividade.TABLE_NAME).document(atividade.id);
    Atividade novaAtividade = atividade.copyWith(id: atividadeRef.documentID);
    atividadeStore.setarAtividade(novaAtividade);
    return atividadeRef.setData(novaAtividade.toMap(), merge: true)
        .then((_) => novaAtividade)
        .whenComplete(() => _hudStore.hide());
  }

  Future toogleAvisar(Atividade atividade, String uid) {
    if (atividade.avisar.contains(uid)) {
      Atividade alterada = atividade.copyWith(avisar: atividade.avisar.where((element) => element != uid).toList());
      salvar(alterada);
    }else{
      Atividade alterada = atividade.copyWith(avisar: atividade.avisar..add(uid));
      salvar(alterada);
    }
  }

  void dispose() {
    this._atividadesStream.cancel();
  }
}
