class Atividade {
  static const String TABLE_NAME = "atividades";

  final String id;
  final String nome;
  final String descricao;
  final String local;
  final DateTime dataHoraInicio;
  final DateTime dataHoraFim;
  final String foto;
  final String usuario;
  final List<String> avisar;

  Atividade({this.id, this.nome, this.descricao, this.local, this.dataHoraInicio, this.dataHoraFim, this.foto, this.usuario, this.avisar = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'local': local,
      'dataHoraInicio': dataHoraInicio?.millisecondsSinceEpoch,
      'dataHoraFim': dataHoraFim?.millisecondsSinceEpoch,
      'foto': foto,
      'usuario': usuario,
      'avisar': avisar
    };
  }

  static Atividade fromMap(Map<String, dynamic> map) {
    return Atividade(
        id: map["id"],
        nome: map["nome"],
        descricao: map["descricao"],
        local: map["local"],
        dataHoraInicio: map["dataHoraInicio"] != null ? DateTime.fromMillisecondsSinceEpoch(map["dataHoraInicio"]) : null,
        dataHoraFim: map["dataHoraFim"] != null ? DateTime.fromMillisecondsSinceEpoch(map["dataHoraFim"]) : null,
        foto: map["foto"],
        usuario: map["usuario"],
        avisar: (map["avisar"] != null && map["avisar"] is Iterable) ? (map["avisar"] as Iterable).map((e) => e.toString()).toList() : []);
  }

  Atividade copyWith({String id, List<String> avisar}) {
    return Atividade(
        id: id ?? this.id,
        nome: this.nome,
        descricao: this.descricao,
        local: this.local,
        dataHoraInicio: this.dataHoraInicio,
        dataHoraFim: this.dataHoraFim,
        foto: this.foto,
        usuario: this.usuario,
        avisar: avisar != null ? avisar : this.avisar);
  }
}
