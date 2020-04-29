import 'package:catolica/actions/atividade_actions.dart';
import 'package:catolica/state/atividade_state.dart';
import 'package:redux/redux.dart';

final atividadesReducer = combineReducers<AtividadeState>([TypedReducer<AtividadeState, AdicionarAtividadeAction>(_adicionarAtividade)]);

AtividadeState _adicionarAtividade(AtividadeState state, AdicionarAtividadeAction action) =>
    state.copyWith(atividades: state.atividades..add(action.atividade));
