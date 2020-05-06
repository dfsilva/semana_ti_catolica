import 'package:catolica/actions/usuario_actions.dart';
import 'package:catolica/state/app_state.dart';
import 'package:catolica/utils/message_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;

  String _email;
  String _senha;

  _login(_ViewModel _viewModel) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ProgressHUD.of(context).showWithText("Entrando....");
      _viewModel.fazerLogin(_email, _senha, (data) {}, (error) {
        ProgressHUD.of(context).dismiss();
        showError(error);
      });
    }
  }

  _buildBody(_ViewModel _viewModel) {
    return Column(
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
                      _login(_viewModel);
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
                  onTap: () {
                    Navigator.of(context).pushNamed("recover");
                  },
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StoreConnector<AppState, _ViewModel>(
      onInit: (store) {
        ProgressHUD.of(context).dismiss();
      },
      converter: (store) => _ViewModel.create(store),
      builder: (_, _ViewModel _viewModel) => _buildBody(_viewModel),
    ));
  }
}

class _ViewModel {
  final Function(String _email, String _senha, Function _onSuccess, Function _onError) fazerLogin;

  _ViewModel({this.fazerLogin});

  factory _ViewModel.create(Store<AppState> store) {
    return _ViewModel(fazerLogin: (_email, _senha, _onSuccess, _onError) {
      store.dispatch(RealizarLoginEmailSenha(email: _email, senha: _senha, onSuccess: _onSuccess, onError: _onError));
    });
  }
}
