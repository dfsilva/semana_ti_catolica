import 'package:catolica/domain/usuario.dart';
import 'package:catolica/state/usuario_state.dart';

class UsuarioService {

   final UsuarioState usuarioState;

  UsuarioService(this.usuarioState);


   Future<Usuario> entrarComEmailSenha(String email, String senha){
      Usuario usuarioLogado = Usuario(nome: "Diego Ferreira", email: "diegosiuniube@gmail.com");
      usuarioState.setUsuario(usuarioLogado);
      return Future.value(usuarioLogado);
   }

   Future<Usuario> criarUsuario(String nome, String email, String senha){
      return Future.value(Usuario(nome: nome, email: email));
   }
}