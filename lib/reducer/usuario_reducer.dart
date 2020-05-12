import 'package:catolica/actions/usuario_actions.dart';
import 'package:catolica/state/usuario_state.dart';
import 'package:redux/redux.dart';

final usuarioReducer = combineReducers<UsuarioState>([
  TypedReducer<UsuarioState, AtualizarUsuarioLogado>(_atualizarValorUsuario),
  TypedReducer<UsuarioState, AtualizarStatusLogin>(_atualizaStatusLogin)
]);

UsuarioState _atualizarValorUsuario(UsuarioState state, AtualizarUsuarioLogado action){
  return state.copyWith(usuario: action.usuario);
}

UsuarioState _atualizaStatusLogin(UsuarioState state, AtualizarStatusLogin action){
  return state.copyWith(statusLogin: action.statusLogin);
}
