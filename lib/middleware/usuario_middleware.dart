import 'dart:async';

import 'package:catolica/actions/usuario_actions.dart';
import 'package:catolica/service/usuario_service.dart';
import 'package:catolica/state/app_state.dart';
import 'package:catolica/state/usuario_state.dart';
import 'package:catolica/utils/navigator_utils.dart';
import 'package:redux/redux.dart';

class UsuarioMiddleware extends MiddlewareClass<AppState> {
  final UsuarioService usuarioService;

  StreamSubscription<StatusLogin> _statusLoginSubscription;

  UsuarioMiddleware({this.usuarioService});

  @override
  call(Store<AppState> store, action, next) {
    next(action);
    if (action is VerificarStatusUsuario) {
      store.dispatch(AtualiarStatusLogin(StatusLogin.carregando));
      this.usuarioService.obterUsuarioLogado().then((value) {
        if (value != null) {
          store.dispatch(AtualizarUsuarioLogado(value));
          store.dispatch(AtualiarStatusLogin(StatusLogin.logado));
          NavigatorUtils.nav.currentState.pushReplacementNamed("home");
        } else {
          store.dispatch(AtualiarStatusLogin(StatusLogin.nao_logado));
          NavigatorUtils.nav.currentState.pushReplacementNamed("login");
        }
      });
    }

    if (action is RealizarLoginEmailSenha) {
      this.usuarioService.entrarComEmailSenha(action.email, action.senha).then((value) {
        if (value != null) {
          store.dispatch(VerificarStatusUsuario());
        } else {
          store.dispatch(AtualiarStatusLogin(StatusLogin.nao_logado));
          action.onError("Usuário ou senha inválidos");
        }
      });
    }

    if (action is FazerLogout) {
      this.usuarioService.logout();
      store.dispatch(VerificarStatusUsuario());
    }

    if (action is Cadastrar) {
      this.usuarioService.criarUsuario(action.nome, action.email, action.senha).then((value) {
        store.dispatch(VerificarStatusUsuario());
      });
    }

    if (action is RecuperarSenha) {
      this.usuarioService.recuperarSenha(action.email)
          .then((value) => action.onSuccess(value))
          .catchError((error) => action.onError(error.message));
    }
  }
}
