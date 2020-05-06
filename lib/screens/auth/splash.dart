import 'package:catolica/actions/usuario_actions.dart';
import 'package:catolica/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector(
          onInit: (store) {
            store.dispatch(VerificarStatusUsuario());
          },
          converter: (Store<AppState> store) => store,
          builder: (_, __) => Center(
                child: Text("Semana de Tecnológia Católica", style: TextStyle(fontSize: 20)),
              )),
    );
  }
}
