

import 'package:catolica/reducer/atividade_reducer.dart';
import 'package:catolica/reducer/usuario_reducer.dart';
import 'package:catolica/state/app_state.dart';

AppState appReducer(AppState state, action){
  return AppState(
    usuarioState: usuarioReducer(state.usuarioState, action),
    atividadeState: atividadesReducer(state.atividadeState, action)
  );
}