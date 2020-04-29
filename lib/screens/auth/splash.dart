import 'package:catolica/actions/usuario_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
          builder: (ctx, conv) => Center(
                child: Text("Semana de Tecnológia Católica", style: TextStyle(fontSize: 20)),
              )),
    );
  }
}
