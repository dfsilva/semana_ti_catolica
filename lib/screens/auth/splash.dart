import 'package:catolica/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    UsuarioService usuarioService = Provider.of<UsuarioService>(context);
    usuarioService.verificarUsuarioAutenticado();
    return Scaffold(
      body: Center(
        child: Text("Semana de Tecnológia Católica", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
