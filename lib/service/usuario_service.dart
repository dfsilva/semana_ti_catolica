import 'dart:async';
import 'dart:convert';

import 'package:catolica/domain/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioService {


  Future<Usuario> entrarComEmailSenha(String email, String senha) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    Usuario usuarioLogado = Usuario(nome: "Diego Ferreira", email: email);
    _preferences.setString("usuario_logado", jsonEncode(usuarioLogado.toJson()));
    return Future.value(usuarioLogado);
  }

  Future<bool> recuperarSenha(String email) async {
    return Future.delayed(Duration(seconds: 5), () {
      return Future.value(true);
    });
  }

  Future<Usuario> criarUsuario(String nome, String email, String senha) async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    Usuario usuarioLogado = Usuario(nome: nome, email: email);
    _preferences.setString("usuario_logado", jsonEncode(usuarioLogado.toJson()));
    return Future.value(Usuario(nome: nome, email: email));
  }

  Future<void> logout() async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove("usuario_logado");
//    usuarioStore.setStatusLogin(StatusLogin.nao_logado);
  }

  Future<Usuario> obterUsuarioLogado() async {
    return Future.delayed(Duration(seconds: 5), () async {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String usuarioStr = _preferences.getString("usuario_logado");
      if (usuarioStr != null) {
        Usuario usuarioLogado = Usuario.fromJson(jsonDecode(usuarioStr));
        return usuarioLogado;
      } else {
        return null;
      }
    });
  }

  void dispose() {
//    _statusLoginSubscription.cancel();
  }
}
