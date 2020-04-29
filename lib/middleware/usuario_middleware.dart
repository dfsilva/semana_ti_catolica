import 'dart:async';

import 'package:catolica/actions/usuario_actions.dart';
import 'package:catolica/service/usuario_service.dart';
import 'package:catolica/state/app_state.dart';
import 'package:catolica/state/usuario_state.dart';
import 'package:redux/redux.dart';

class UsuarioMiddleware extends MiddlewareClass<AppState> {
  final UsuarioService usuarioService;

  StreamSubscription<StatusLogin> _statusLoginSubscription;

  UsuarioMiddleware({this.usuarioService});

  @override
  call(Store<AppState> store, action, next) {
    next(action);

    if (action is VerificarStatusUsuario) {
      this.usuarioService.obterUsuarioLogado().then((value) {
        if (value != null) {
          store.dispatch(AtualizarUsuarioLogado(value));
          store.dispatch(AtualiarStatusLogin(StatusLogin.logado));

        }else{
          store.dispatch(AtualiarStatusLogin(StatusLogin.nao_logado));
        }
      });
    }
  }
}
