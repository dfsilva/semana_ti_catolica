// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UsuarioState on _UsuarioState, Store {
  final _$usuarioAtom = Atom(name: '_UsuarioState.usuario');

  @override
  Usuario get usuario {
    _$usuarioAtom.context.enforceReadPolicy(_$usuarioAtom);
    _$usuarioAtom.reportObserved();
    return super.usuario;
  }

  @override
  set usuario(Usuario value) {
    _$usuarioAtom.context.conditionallyRunInAction(() {
      super.usuario = value;
      _$usuarioAtom.reportChanged();
    }, _$usuarioAtom, name: '${_$usuarioAtom.name}_set');
  }

  final _$_UsuarioStateActionController =
      ActionController(name: '_UsuarioState');

  @override
  dynamic setUsuario(Usuario _usuario) {
    final _$actionInfo = _$_UsuarioStateActionController.startAction();
    try {
      return super.setUsuario(_usuario);
    } finally {
      _$_UsuarioStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'usuario: ${usuario.toString()}';
    return '{$string}';
  }
}
