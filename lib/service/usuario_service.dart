import 'dart:async';
import 'dart:io';

import 'package:catolica/domain/usuario.dart';
import 'package:catolica/stores/hud_store.dart';
import 'package:catolica/stores/usuario_store.dart';
import 'package:catolica/utils/message_utils.dart';
import 'package:catolica/utils/navigator_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class UsuarioService {
  final UsuarioStore usuarioStore;
  final FirebaseAuth _auth;
  final Firestore _firestore;
  final HudStore _hudStore;
  final FirebaseMessaging _firebaseMessaging;

  StreamSubscription _authSubscription;
  StreamSubscription _userDataSubscription;

  UsuarioService(this.usuarioStore, this._auth, this._firestore, this._hudStore, this._firebaseMessaging) {
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
          _registerFcmToken(fuser);
          escutarDadosUsuario(fuser);
          NavigatorUtils.nav.currentState.pushReplacementNamed("home");
        }).catchError((error) {
          showError("Erro ao recuperar dados do usuario");
          logout();
        });
      }
    });
  }

  escutarDadosUsuario(Usuario usuario) {
    _userDataSubscription = usuarioStream(usuario).listen((newUser) {
      usuarioStore.setUsuario(newUser);
    });
  }

  Stream<Usuario> usuarioStream(Usuario usuario) {
    return _firestore.document("usuarios/${usuario.uid}").snapshots().map((event) => Usuario.fromJson(event.data));
  }

  Future<AuthResult> entrarComEmailSenha(String email, String senha) async {
    _hudStore.show("Entrando...");
    return _auth.signInWithEmailAndPassword(email: email, password: senha).whenComplete(() => _hudStore.hide());
  }

  Future<void> recuperarSenha(String email) async {
    _hudStore.show("Enviando...");
    return _auth.sendPasswordResetEmail(email: email).whenComplete(() => _hudStore.hide());
  }

  Future<void> enviarFoto(String uid, File foto) {
    if (foto.existsSync()) {
      StorageReference storageReference = FirebaseStorage().ref().child("profile_pics/$uid/${basename(foto.path)}");
      storageReference.putFile(foto, StorageMetadata(customMetadata: {"uid": uid}));
    }
  }

  Future<void> criarUsuario(String nome, String email, String senha, File file) {
    _hudStore.show("Cadastrando...");
    _authSubscription?.cancel();

    return _auth.createUserWithEmailAndPassword(email: email, password: senha).then((authResult) async {
      enviarFoto(authResult.user.uid, file);
      await _firestore
          .collection("usuarios")
          .document(authResult.user.uid)
          .setData(Usuario(uid: authResult.user.uid, email: email, admin: false, nome: nome).toJson());
    }).whenComplete(() {
      escutarStatusLogin();
      _hudStore.hide();
    });
  }

  Future<void> alterarUsuario(Usuario usuario, {File file}) {
    _hudStore.show("Alterando...");
    DocumentReference dr = _firestore.document("usuarios/${usuario.uid}");
    return dr.setData(usuario.toJson(), merge: true).whenComplete(() {
      if (file != null) {
        enviarFoto(usuario.uid, file);
      }
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
    _userDataSubscription?.cancel();
  }

  Future<void> _registerFcmToken(Usuario usuario) {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) async {
      _firestore.collection("usuarios/${usuario.uid}/devices")
          .where("fcmToken", isEqualTo: token).getDocuments().then((querySnp) async {
        if (querySnp.documents.isEmpty) {
          await _createFcmToken(usuario, token);
        } else {
          await _updateFcmToken(usuario, token, querySnp.documents.first.documentID);
        }
      });
    });
  }

  Future _createFcmToken(Usuario usuario, String token) async {
    DocumentReference dr = _firestore.collection("usuarios/${usuario.uid}/devices").document();
    Map<String, dynamic> deviceData = Map<String, dynamic>();
    deviceData["fcmToken"] = token;
    deviceData["created"] = DateTime.now();

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData["model"] = androidInfo.model;
      deviceData["so"] = "android";
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData["model"] = iosInfo.utsname.machine;
      deviceData["so"] = "ios";
    }
    dr.setData(deviceData);
  }

  Future _updateFcmToken(Usuario usuario, String token, String docId) async {
    DocumentReference dr = _firestore.collection("usuarios/${usuario.uid}/devices").document(docId);
    Map<String, dynamic> deviceData = Map<String, dynamic>();
    deviceData["fcmToken"] = token;
    deviceData["created"] = DateTime.now();

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData["model"] = androidInfo.model;
      deviceData["so"] = "android";
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData["model"] = iosInfo.utsname.machine;
      deviceData["so"] = "ios";
    }
    dr.setData(deviceData, merge: true);
  }
}
