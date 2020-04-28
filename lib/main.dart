import 'package:bot_toast/bot_toast.dart';
import 'package:catolica/screens/atividade/atividade.dart';
import 'package:catolica/screens/auth/login.dart';
import 'package:catolica/screens/auth/recover.dart';
import 'package:catolica/screens/auth/register.dart';
import 'package:catolica/screens/auth/splash.dart';
import 'package:catolica/screens/home/home.dart';
import 'package:catolica/service/atividade_service.dart';
import 'package:catolica/service/usuario_service.dart';
import 'package:catolica/stores/atividade_store.dart';
import 'package:catolica/stores/usuario_store.dart';
import 'package:catolica/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: MultiProvider(
        providers: [
          Provider<UsuarioService>(
            create: (_) => UsuarioService(UsuarioStore()),
            dispose: (ctx, usuarioService) {
              usuarioService.dispose();
            },
          ),
          Provider<AtividadeService>(
            create: (_) => AtividadeService(AtividadeStore()),
            dispose: (ctx, atividadeService) {
              atividadeService.dispose();
            },
          )
        ],
        child: MaterialApp(
          title: 'Semana de TI Católica',
          navigatorObservers: [BotToastNavigatorObserver()],
          navigatorKey: NavigatorUtils.nav,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              buttonTheme: ButtonThemeData(buttonColor: Colors.blue[700], textTheme: ButtonTextTheme.primary, height: 50)),
          initialRoute: "splash",
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
