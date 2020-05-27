class Atividade {
  static const String TABLE_NAME = "atividade";

  final int id;
  final String nome;
  final String descricao;
  final String local;
  final DateTime dataHoraInicio;
  final DateTime dataHoraFim;
  final String foto;
  final String usuario;

  Atividade({this.id, this.nome, this.descricao, this.local, this.dataHoraInicio, this.dataHoraFim, this.foto, this.usuario});

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
        usuario: map["usuario"]);
  }

  copyWith({int id}) {
    return Atividade(
        id: id,
        nome: this.nome,
        descricao: this.descricao,
        local: this.local,
        dataHoraInicio: this.dataHoraInicio,
        dataHoraFim: this.dataHoraFim,
        foto: this.foto,
        usuario: this.usuario);
  }
}
