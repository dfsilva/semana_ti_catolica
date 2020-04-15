import 'package:catolica/domain/atividade.dart';

class AtividadeService {
  Future<List<Atividade>> buscarAtividades() {
    return Future.delayed(Duration(seconds: 5), () {
      //TODO: retornar lista de atividades da ativiade_store que deve ser criada
      return Future.value([]);
    });
  }

  Future<Atividade> salvar(Atividade atividade){
    //TODO: persistir a atividade em uma lista de atividades
    //no estado global dentro de atividade_store(atividade_store deve ser criada)

    return Future.error("Nao implementado");
  }


  void dispose(){

  }
}
