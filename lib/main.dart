import 'package:bot_toast/bot_toast.dart';
import 'package:catolica/screens/auth/login.dart';
import 'package:catolica/screens/auth/register.dart';
import 'package:catolica/screens/home/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: MaterialApp(
        title: 'Semana de TI Católica',
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue[700],
            textTheme: ButtonTextTheme.primary,
            height: 50
          )
        ),
        initialRoute: "login",
        routes: {
          "login": (context) => LoginScreen(),
          "home": (context) => HomeScreen(),
          "register": (context) => RegisterScreen(),
        },
      ),
    );
  }
}

