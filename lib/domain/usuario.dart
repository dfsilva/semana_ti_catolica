class Usuario {
  static const String TABLE_NAME = "usuarios";

  final String uid;
  final String nome;
  final String email;
  final bool admin;
  final String foto;

  Usuario({this.uid, this.nome, this.email, this.admin = true, this.foto});

  Map<String, Object> toJson() {
    return {"uid": this.uid, "nome": this.nome, "email": this.email, "admin": this.admin, "foto": this.foto};
  }

  static fromJson(Map<String, Object> json) {
    if (json == null) return null;
    return Usuario(uid: json["uid"],
        nome: json["nome"],
        email: json["email"],
        admin: json["admin"] ?? false,
        foto: json["foto"]);
  }
}
