class Usuario {
  final String nome;
  final String email;
  final bool admin;

  Usuario({this.nome, this.email, this.admin = true});

  Map<String, Object> toJson() {
    return {"nome": this.nome, "email": this.email, "admin": this.admin};
  }

  static fromJson(Map<String, Object> json) {
    return Usuario(nome: json["nome"], email: json["email"], admin: json["admin"] ?? false);
  }
}
