import 'package:catolica/domain/atividade.dart';

class AtividadeState {
  final List<Atividade> atividades;

  AtividadeState(this.atividades);
  
  AtividadeState copyWith({List<Atividade> atividades}) {
    return AtividadeState(atividades);
  }
}
