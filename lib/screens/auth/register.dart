import 'package:catolica/actions/usuario_actions.dart';
import 'package:catolica/state/app_state.dart';
import 'package:catolica/utils/message_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;

  String _nome;
  String _email;
  String _senha;

  FocusNode _focusNome;
  FocusNode _focusEmail;
  FocusNode _focusSenha;

  @override
  void initState() {
    super.initState();
    this._focusNome = FocusNode();
    this._focusEmail = FocusNode();
    this._focusSenha = FocusNode();
  }

  @override
  void dispose() {
    this._focusNome.dispose();
    this._focusEmail.dispose();
    this._focusSenha.dispose();

    super.dispose();
  }

  _register(_ViewModel _viewModel) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ProgressHUD.of(context).showWithText("Cadastrando...");
      _viewModel.cadastrar(_nome, _email, _senha, (data) {}, (error) {
        showError(error);
      });
    }
  }

  _buildBody(_ViewModel _viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar-se"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      focusNode: this._focusNome,
                      validator: (nome) {
                        if (nome.isEmpty) {
                          return "Informe o nome";
                        }
                        return null;
                      },
                      onFieldSubmitted: (nome) {
                        this._focusNome.unfocus();
                        this._focusEmail.requestFocus();
                      },
                      onSaved: (nome) {
                        this._nome = nome;
                      },
                      decoration: InputDecoration(hintText: "nome", labelText: "nome", icon: Icon(Icons.account_box)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _focusEmail,
                      textInputAction: TextInputAction.next,
                      validator: (email) {
                        if (email.isEmpty) {
                          return "Informe o email.";
                        }
                        return null;
                      },
                      onFieldSubmitted: (nome) {
                        this._focusEmail.unfocus();
                        this._focusSenha.requestFocus();
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
                      textInputAction: TextInputAction.send,
                      focusNode: _focusSenha,
                      validator: (senha) {
                        if (senha.isEmpty) {
                          return "Informe a senha.";
                        }
                        if (senha.length < 6) {
                          return "A senha deve conter mais de 6 caracteres.";
                        }
                        return null;
                      },
                      onFieldSubmitted: (nome) {
                        this._focusSenha.unfocus();
                        _register(_viewModel);
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
                      child: Text("Enviar"),
                      onPressed: () {
                        _register(_viewModel);
                      },
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (_, _ViewModel _viewModel) => _buildBody(_viewModel),
    );
  }
}

class _ViewModel {
  final Function(String _nome, String _email, String _senha, Function _onSuccess, Function _onError) cadastrar;

  _ViewModel({this.cadastrar});

  factory _ViewModel.create(Store<AppState> store) {
    return _ViewModel(cadastrar: (_nome, _email, _senha, _onSuccess, _onError) {
      store.dispatch(Cadastrar(nome: _nome, email: _email, senha: _senha, onSuccess: _onSuccess, onError: _onError));
    });
  }
}
