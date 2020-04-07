import 'package:catolica/domain/usuario.dart';
import 'package:mobx/mobx.dart';


abstract class _UsuarioState with Store{

  @observable
  Usuario usuario;

  @action
  setUsuario(Usuario _usuario){
    this.usuario = _usuario;
  }

}