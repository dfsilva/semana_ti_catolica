import 'package:catolica/state/atividade_state.dart';
import 'package:catolica/state/usuario_state.dart';

class AppState {
  final AtividadeState atividadeState;
  final UsuarioState usuarioState;

  AppState({this.atividadeState, this.usuarioState});
}
