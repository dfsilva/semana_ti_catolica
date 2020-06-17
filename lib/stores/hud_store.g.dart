// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hud_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HudStore on _HudStore, Store {
  final _$exibindoAtom = Atom(name: '_HudStore.exibindo');

  @override
  bool get exibindo {
    _$exibindoAtom.context.enforceReadPolicy(_$exibindoAtom);
    _$exibindoAtom.reportObserved();
    return super.exibindo;
  }

  @override
  set exibindo(bool value) {
    _$exibindoAtom.context.conditionallyRunInAction(() {
      super.exibindo = value;
      _$exibindoAtom.reportChanged();
    }, _$exibindoAtom, name: '${_$exibindoAtom.name}_set');
  }

  final _$msgAtom = Atom(name: '_HudStore.msg');

  @override
  String get msg {
    _$msgAtom.context.enforceReadPolicy(_$msgAtom);
    _$msgAtom.reportObserved();
    return super.msg;
  }

  @override
  set msg(String value) {
    _$msgAtom.context.conditionallyRunInAction(() {
      super.msg = value;
      _$msgAtom.reportChanged();
    }, _$msgAtom, name: '${_$msgAtom.name}_set');
  }

  final _$_HudStoreActionController = ActionController(name: '_HudStore');

  @override
  dynamic show(String msg) {
    final _$actionInfo = _$_HudStoreActionController.startAction();
    try {
      return super.show(msg);
    } finally {
      _$_HudStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic hide() {
    final _$actionInfo = _$_HudStoreActionController.startAction();
    try {
      return super.hide();
    } finally {
      _$_HudStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'exibindo: ${exibindo.toString()},msg: ${msg.toString()}';
    return '{$string}';
  }
}
