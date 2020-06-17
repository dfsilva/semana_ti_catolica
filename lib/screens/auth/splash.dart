import 'package:catolica/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Semana de Tecnológia Católica", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
