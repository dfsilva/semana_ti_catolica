import 'package:catolica/actions/usuario_actions.dart';
import 'package:catolica/state/app_state.dart';
import 'package:catolica/utils/message_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RecoverScreen extends StatefulWidget {
  @override
  RecoverScreenState createState() => RecoverScreenState();
}

class RecoverScreenState extends State<RecoverScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  FocusNode _focusEmail;

  @override
  void initState() {
    super.initState();
    this._focusEmail = FocusNode();
  }

  @override
  void dispose() {
    this._focusEmail.dispose();
    super.dispose();
  }

  _recover(_ViewModel _viewModel) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ProgressHUD.of(context).showWithText("Enviando...");
      _viewModel.recuperarSenha(_email, (data) {
        ProgressHUD.of(context).dismiss();
        showInfo("Senha enviada com sucesso!");
        Navigator.of(context).pop();
      }, (error) {
        ProgressHUD.of(context).dismiss();
        print("Errooooooo!!!!!");
        showError("Erro ao fazer login");
      });
    }
  }

  _buildBody(_ViewModel _viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperar sua senha"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _focusEmail,
                    textInputAction: TextInputAction.send,
                    validator: (email) {
                      if (email.isEmpty) {
                        return "Informe o email.";
                      }
                      return null;
                    },
                    onFieldSubmitted: (nome) {
                      this._focusEmail.unfocus();
                    },
                    onSaved: (email) {
                      this._email = email;
                    },
                    decoration: InputDecoration(hintText: "email", labelText: "email", icon: Icon(Icons.email)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                  child: RaisedButton(
                    child: Text("Recuperar senha"),
                    onPressed: () {
                      _recover(_viewModel);
                    },
                  ),
                ),
              ],
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
  final Function(String _email, Function _onSuccess, Function _onError) recuperarSenha;

  _ViewModel({this.recuperarSenha});

  factory _ViewModel.create(Store<AppState> store) {
    return _ViewModel(recuperarSenha: (_email, _onSuccess, _onError) {
      store.dispatch(RecuperarSenha(email: _email, onSuccess: _onSuccess, onError: _onError));
    });
  }
}
