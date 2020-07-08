import 'package:bot_toast/bot_toast.dart';
import 'package:catolica/db/DBHelper.dart';
import 'package:catolica/parent.dart';
import 'package:catolica/screens/atividade/atividade.dart';
import 'package:catolica/screens/auth/login.dart';
import 'package:catolica/screens/auth/recover.dart';
import 'package:catolica/screens/auth/register.dart';
import 'package:catolica/screens/auth/splash.dart';
import 'package:catolica/screens/home/home.dart';
import 'package:catolica/service/atividade_service.dart';
import 'package:catolica/service/usuario_service.dart';
import 'package:catolica/stores/atividade_store.dart';
import 'package:catolica/stores/hud_store.dart';
import 'package:catolica/stores/usuario_store.dart';
import 'package:catolica/utils/navigator_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DbHelper dbHelper = new DbHelper();

  @override
  Widget build(BuildContext context) {
    Firestore.instance.settings(persistenceEnabled: true, cacheSizeBytes: -1);
    return BotToastInit(
      child: MultiProvider(
        providers: [
          Provider<HudStore>(
            create: (_) => HudStore(),
            lazy: false,
          ),
          Provider<UsuarioStore>(
            create: (_) => UsuarioStore(),
            lazy: false,
          ),
          ProxyProvider2<HudStore, UsuarioStore, UsuarioService>(
            update: (_, hudStore, usuarioStore, __) => UsuarioService(usuarioStore, FirebaseAuth.instance, Firestore.instance, hudStore, FirebaseMessaging()),
            lazy: false,
            dispose: (_, usuarioService) {
              usuarioService.dispose();
            },
          ),
          ProxyProvider2<HudStore, UsuarioStore, AtividadeService>(
            update: (_, hudStore, usuarioStore, __) => AtividadeService(AtividadeStore(), dbHelper, Firestore.instance, hudStore, usuarioStore),
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
          builder: (ctx, widget) => ParentWidget(widget),
        ),
      ),
    );
  }
}
