import 'package:catolica/domain/usuario.dart';
import 'package:catolica/state/usuario_state.dart';

class VerificarStatusUsuario {}

class RealizarLoginEmailSenha {
  final String email;
  final String senha;

  RealizarLoginEmailSenha({this.email, this.senha});
}

class AtualizarUsuarioLogado {
  final Usuario usuario;

  AtualizarUsuarioLogado(this.usuario);
}

class AtualiarStatusLogin {
  final StatusLogin statusLogin;

  AtualiarStatusLogin(this.statusLogin);

}
