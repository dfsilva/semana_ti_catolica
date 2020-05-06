import 'package:catolica/domain/usuario.dart';
import 'package:catolica/state/usuario_state.dart';

class VerificarStatusUsuario {}

class RealizarLoginEmailSenha {
  final String email;
  final String senha;
  final Function(dynamic data) onSuccess;
  final Function(dynamic error) onError;

  RealizarLoginEmailSenha({this.email, this.senha, this.onSuccess, this.onError});
}

class Cadastrar {
  final String nome;
  final String email;
  final String senha;
  final Function(dynamic data) onSuccess;
  final Function(dynamic error) onError;

  Cadastrar({this.nome, this.email, this.senha, this.onSuccess, this.onError});
}

class RecuperarSenha {
  final String email;
  final Function(dynamic data) onSuccess;
  final Function(dynamic error) onError;

  RecuperarSenha({this.email, this.onSuccess, this.onError});
}

class FazerLogout{

}

class AtualizarUsuarioLogado {
  final Usuario usuario;

  AtualizarUsuarioLogado(this.usuario);
}

class AtualiarStatusLogin {
  final StatusLogin statusLogin;

  AtualiarStatusLogin(this.statusLogin);

}
