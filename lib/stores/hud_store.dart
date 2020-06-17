import 'package:mobx/mobx.dart';

part 'hud_store.g.dart';

class HudStore = _HudStore with _$HudStore;

abstract class _HudStore with Store {
  @observable
  bool exibindo = false;

  @observable
  String msg = "Carregando...";

  @action
  show(String msg) {
    this.msg = msg;
    this.exibindo = true;
  }

  @action
  hide() {
    this.msg = "Carregando...";
    this.exibindo = false;
  }

}
