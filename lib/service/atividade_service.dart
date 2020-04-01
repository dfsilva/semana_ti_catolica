import 'package:catolica/domain/atividade.dart';

class AtividadeService {
  Future<List<Atividade>> buscarAtividades() {
    return Future.delayed(Duration(seconds: 5), () {
      return Future.value([
        Atividade(
            nome: "Evento 1",
            dataHoraInicio: DateTime.now(),
            dataHoraFim: DateTime.now(),
            descricao: "lkj falsj dflak sjdflka jsldkfjalskdjflasd lkj falksjd fa"
                "lfj alsdjf laksj flkajsdlf asd"
                "lfkj alksdf jlaksj dflka sjd"
                "lj flaksdj flkasj dflka jsldfk alskjd flkas "
                "lj lkfajsldkfj aslkdfj alskjdf lkasj dfkl ajsdklfj asd"
                "lj flkasjd flkajs dflka jsdlkf jasldfjalskd "
                "lf ajslkdf jalskdfj alsdjf lasjd flkasj dflaj sdlf "
                "laf jslfd jalksdj flkas jdflasjdlf jaslkdfj laksdj fljas d",
            local: "lab 201",
            foto: "https://picsum.photos/300/150"),
        Atividade(
            nome: "Evento 2",
            dataHoraInicio: DateTime.now(),
            dataHoraFim: DateTime.now(),
            descricao: "lkj falsj dflak sjdflka jsldkfjalskdjflasd",
            local: "lab 201",
            foto: "https://picsum.photos/300/150"),
        Atividade(
            nome: "Evento 3",
            dataHoraInicio: DateTime.now(),
            dataHoraFim: DateTime.now(),
            descricao: "lkj falsj dflak sjdflka jsldkfjalskdjflasd",
            local: "lab 201",
            foto: "https://picsum.photos/300/150"),
        Atividade(
            nome: "Evento 4",
            dataHoraInicio: DateTime.now(),
            dataHoraFim: DateTime.now(),
            descricao: "lkj falsj dflak sjdflka jsldkfjalskdjflasd",
            local: "lab 201",
            foto: "https://picsum.photos/300/150"),
        Atividade(
            nome: "Evento 5",
            dataHoraInicio: DateTime.now(),
            dataHoraFim: DateTime.now(),
            descricao: "lkj falsj dflak sjdflka jsldkfjalskdjflasd",
            local: "lab 201",
            foto: "https://picsum.photos/300/150"),
        Atividade(
            nome: "Evento 6",
            dataHoraInicio: DateTime.now(),
            dataHoraFim: DateTime.now(),
            descricao: "lkj falsj dflak sjdflka jsldkfjalskdjflasd",
            local: "lab 201",
            foto: "https://picsum.photos/300/150")
      ]);
    });
  }
}
