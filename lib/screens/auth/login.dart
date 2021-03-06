
import 'package:bot_toast/bot_toast.dart';
import 'package:catolica/service/usuario_service.dart';
import 'package:catolica/utils/message_utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioService = UsuarioService();

  bool _showPassword = false;

  String _email;
  String _senha;

  _login() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try{
        _usuarioService.entrarComEmailSenha(_email, _senha).then((usuario){
          if(usuario != null){
            Navigator.of(context).pushReplacementNamed("home");
          }else{
            showError("Usuário não cadastrado");
          }
        }).catchError((error){
          print("Errooooooo!!!!!");
          showError("Erro ao fazer login");
        });
      }catch(e){
        showError("Erro ao fazer login");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green,
            ),
          ),
          Expanded(
            flex: 2,
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      validator: (email) {
                        if (email.isEmpty) {
                          return "Informe o email.";
                        }
                        return null;
                      },
                      onSaved: (email) {
                        this._email = email;
                      },
                      decoration: InputDecoration(hintText: "email", labelText: "email", icon: Icon(Icons.email)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (senha) {
                        if (senha.isEmpty) {
                          return "Informe a senha.";
                        }
                        if (senha.length < 6) {
                          return "A senha deve conter mais de 6 caracteres.";
                        }
                        return null;
                      },
                      onSaved: (senha) {
                        this._senha = senha;
                      },
                      decoration: InputDecoration(
                          hintText: "senha",
                          labelText: "senha",
                          icon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  this._showPassword = !_showPassword;
                                });
                              })),
                      obscureText: !_showPassword,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                    child: RaisedButton(
                      child: Text("Entrar"),
                      onPressed: () {
                        _login();
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("register");
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Cadastrar", textAlign: TextAlign.center, style: TextStyle(color: Colors.blue[700])),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Recuperar senha",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
