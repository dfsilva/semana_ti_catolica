import 'package:catolica/domain/usuario.dart';
import 'package:mobx/mobx.dart';
part 'usuario_state.g.dart';

class UsuarioState = _UsuarioState with _$UsuarioState;

abstract class _UsuarioState with Store{

  @observable
  Usuario usuario;

  @action
  setUsuario(Usuario _usuario){
    this.usuario = _usuario;
  }

}