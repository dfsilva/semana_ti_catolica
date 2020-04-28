class Usuario {
  final String uid;
  final String nome;
  final String email;
  final bool admin;

  Usuario({this.uid, this.nome, this.email, this.admin = true});

  Map<String, Object> toJson() {
    return {"uid": this.uid, "nome": this.nome, "email": this.email, "admin": this.admin};
  }

  static fromJson(Map<String, Object> json) {
    return Usuario(uid: json["uid"], nome: json["nome"], email: json["email"], admin: json["admin"] ?? false);
  }
}
