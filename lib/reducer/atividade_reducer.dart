import 'package:catolica/actions/atividade_actions.dart';
import 'package:catolica/domain/atividade.dart';
import 'package:catolica/state/atividade_state.dart';
import 'package:redux/redux.dart';

final atividadesReducer = combineReducers<AtividadeState>([TypedReducer<AtividadeState, AdicionarAtividadeAction>(_adicionarAtividade)]);

AtividadeState _adicionarAtividade(AtividadeState state, AdicionarAtividadeAction action){
  return state.copyWith(atividades: [...state.atividades, action.atividade]);
}

