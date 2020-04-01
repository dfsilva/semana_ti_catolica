import 'package:catolica/domain/usuario.dart';

class UsuarioService {

   Future<Usuario> entrarComEmailSenha(String email, String senha){
      return Future.value(Usuario(nome: "Diego Ferreira", email: "diegosiuniube@gmail.com"));
   }

   Future<Usuario> criarUsuario(String nome, String email, String senha){
      return Future.value(Usuario(nome: nome, email: email));
   }
}