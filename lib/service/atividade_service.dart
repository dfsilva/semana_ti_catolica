import 'package:catolica/domain/atividade.dart';
//import 'package:catolica/stores/atividade_state.dart';

class AtividadeService {

//  final AtividadeStore atividadeStore;

  AtividadeService();

  Future<List<Atividade>> buscarAtividades() {
//    return Future.value(atividadeStore.atividades);
  }

  Future<Atividade> salvar(Atividade atividade){
//    atividadeStore.adicionarAtividade(atividade);
    return Future.value(atividade);
  }

  void dispose(){

  }
}
