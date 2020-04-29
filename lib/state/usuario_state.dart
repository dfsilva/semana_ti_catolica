import 'package:catolica/domain/usuario.dart';

enum StatusLogin { carregando, logado, nao_logado }

class UsuarioState {
  final Usuario usuario;
  final StatusLogin statusLogin;

  UsuarioState({this.usuario, this.statusLogin});

  UsuarioState copyWith({Usuario usuario, StatusLogin statusLogin}) {
    return UsuarioState(usuario: usuario ?? this.usuario, statusLogin: statusLogin ?? this.statusLogin);
  }
}
