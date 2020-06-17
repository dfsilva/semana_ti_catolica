import 'dart:async';

import 'package:catolica/domain/usuario.dart';
import 'package:catolica/stores/hud_store.dart';
import 'package:catolica/stores/usuario_store.dart';
import 'package:catolica/utils/message_utils.dart';
import 'package:catolica/utils/navigator_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioService {
  final UsuarioStore usuarioStore;
  final FirebaseAuth _auth;
  final Firestore _firestore;
  final HudStore _hudStore;
  StreamSubscription _authSubscription;

  UsuarioService(this.usuarioStore, this._auth, this._firestore, this._hudStore) {
    escutarStatusLogin();
  }

  escutarStatusLogin() {
    this._authSubscription = _auth.onAuthStateChanged.listen((userData) {
      if (userData == null) {
        usuarioStore.setStatusLogin(StatusLogin.nao_logado);
        NavigatorUtils.nav.currentState.pushReplacementNamed("login");
      } else {
        usuarioStore.setStatusLogin(StatusLogin.logado);
        obterUsuarioPorEmail(userData.email).then((fuser) {
          usuarioStore.setUsuario(fuser);
          NavigatorUtils.nav.currentState.pushReplacementNamed("home");
        }).catchError((error) {
          showError("Erro ao recuperar dados do usuario");
          logout();
        });
      }
    });
  }

  Future<AuthResult> entrarComEmailSenha(String email, String senha) async {
    _hudStore.show("Entrando...");
    return _auth.signInWithEmailAndPassword(email: email, password: senha)
        .whenComplete(() => _hudStore.hide());
  }

  Future<void> recuperarSenha(String email) async {
    _hudStore.show("Enviando...");
    return _auth.sendPasswordResetEmail(email: email)
        .whenComplete(() => _hudStore.hide());
  }

  Future<void> criarUsuario(String nome, String email, String senha) {
    _hudStore.show("Cadastrando...");
    _authSubscription?.cancel();
    return _auth.createUserWithEmailAndPassword(email: email, password: senha).then((authResult) async {
      await _firestore
          .collection("usuarios")
          .document(authResult.user.uid)
          .setData(Usuario(uid: authResult.user.uid, email: email, admin: false, nome: nome).toJson());
    }).whenComplete((){
      escutarStatusLogin();
      _hudStore.hide();
    });
  }

  Future<Usuario> obterUsuarioPorEmail(String email) {
    return _firestore
        .collection("usuarios")
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((qsnp) => Usuario.fromJson(qsnp.documents?.first?.data));
  }

  Future<void> logout() {
    _auth.signOut();
  }

  void dispose() {
    _authSubscription?.cancel();
  }
}
