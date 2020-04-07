import 'dart:convert';

import 'package:catolica/domain/usuario.dart';
import 'package:catolica/state/usuario_state.dart';
import 'package:catolica/utils/navigator_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioService {
  final UsuarioState usuarioState;

  UsuarioService(this.usuarioState);

  Future<Usuario> entrarComEmailSenha(String email, String senha) async {
    Usuario usuarioLogado = Usuario(nome: "Diego Ferreira", email: email);
    (await SharedPreferences.getInstance()).setString("usuario_logado", jsonEncode(usuarioLogado.toJson()));
    usuarioState.setUsuario(usuarioLogado);
    return Future.value(usuarioLogado);
  }

  Future<Usuario> criarUsuario(String nome, String email, String senha) {
    return Future.value(Usuario(nome: nome, email: email));
  }

  Future<void> logout() {
    //todo: codificar logout do usuario
  }

  Future<Usuario> verificarUsuarioAutenticado() async {
    return Future.delayed(Duration(seconds: 10), () {
      return SharedPreferences.getInstance().then((sharedPref) {
        String usuarioStr = sharedPref.getString("usuario_logado");
        if (usuarioStr != null) {
          Usuario usuarioLogado = Usuario.fromJson(jsonDecode(usuarioStr));
          usuarioState.setUsuario(usuarioLogado);
          usuarioState.setStatusLogin("logado");
          NavigatorUtils.nav.currentState.pushReplacementNamed("home");
          return usuarioLogado;
        } else {
          NavigatorUtils.nav.currentState.pushReplacementNamed("login");
          usuarioState.setStatusLogin("nao_logado");
          return null;
        }
      });
    });
  }
}
