import 'package:bot_toast/bot_toast.dart';
import 'package:catolica/middleware/usuario_middleware.dart';
import 'package:catolica/reducer/app_reducer.dart';
import 'package:catolica/screens/atividade/atividade.dart';
import 'package:catolica/screens/auth/login.dart';
import 'package:catolica/screens/auth/recover.dart';
import 'package:catolica/screens/auth/register.dart';
import 'package:catolica/screens/auth/splash.dart';
import 'package:catolica/screens/home/home.dart';
import 'package:catolica/service/usuario_service.dart';
import 'package:catolica/state/app_state.dart';
import 'package:catolica/state/atividade_state.dart';
import 'package:catolica/state/usuario_state.dart';
import 'package:catolica/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Store<AppState> store = Store<AppState>(appReducer,
      initialState: AppState(
        atividadeState: AtividadeState(const []),
        usuarioState: UsuarioState(statusLogin: StatusLogin.nao_logado),
      ),
      middleware: [UsuarioMiddleware(usuarioService: UsuarioService())]);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: BotToastInit(
        child: MaterialApp(
          title: 'Semana de TI Católica',
          navigatorObservers: [BotToastNavigatorObserver()],
          navigatorKey: NavigatorUtils.nav,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              buttonTheme: ButtonThemeData(buttonColor: Colors.blue[700],
                  textTheme: ButtonTextTheme.primary, height: 50)),
          initialRoute: "splash",
          builder: (ctx, widget) => Scaffold(
            body: ProgressHUD(
              child: widget,
            ),
          ),
          routes: {
            "splash": (context) => Splash(),
            "login": (context) => LoginScreen(),
            "home": (context) => HomeScreen(),
            "register": (context) => RegisterScreen(),
            "recover": (context) => RecoverScreen(),
            "atividade": (context) => AtividadeScreen(),
          },
        ),
      ),
    );
  }
}
