import 'package:catolica/domain/atividade.dart';
import 'package:mobx/mobx.dart';

part 'atividade_store.g.dart';

class AtividadeStore = _AtividadeStore with _$AtividadeStore;

abstract class _AtividadeStore with Store {
  @observable
  ObservableMap<String, Atividade> atividades = Map<String, Atividade>().asObservable();

  @action
  setarAtividade(Atividade atividade) {
    atividades[atividade.id] = atividade;
  }

  @action
  setAtividades(List<Atividade> atividades) {
    this.atividades.clear();
    this.atividades = Map<String, Atividade>.fromIterable(atividades, key: (el) => el.id, value: (el) => el).asObservable();
  }

  @computed
  int get quantidadeAtividades {
    return atividades.length;
  }
}
