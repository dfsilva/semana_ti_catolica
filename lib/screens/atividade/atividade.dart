import 'package:catolica/actions/atividade_actions.dart';
import 'package:catolica/domain/atividade.dart';
import 'package:catolica/domain/usuario.dart';
import 'package:catolica/state/app_state.dart';
import 'package:catolica/widgets/form/date_time_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

class AtividadeScreen extends StatefulWidget {
  @override
  AtividadeScreenState createState() => AtividadeScreenState();
}

class AtividadeScreenState extends State<AtividadeScreen> {
  final _formKey = GlobalKey<FormState>();

  String _nome;
  String _descricao;
  String _local;
  DateTime _dataHoraInicio;
  DateTime _dataHoraFim;

  FocusNode _focusNome;
  FocusNode _focusDescricao;
  FocusNode _focusLocal;
  FocusNode _focusDataHoraInicio;
  FocusNode _focusDataHoraFim;

  @override
  void initState() {
    super.initState();
    this._focusNome = FocusNode();
    this._focusDescricao = FocusNode();
    this._focusLocal = FocusNode();
    this._focusDataHoraInicio = FocusNode();
    this._focusDataHoraFim = FocusNode();
  }

  @override
  void dispose() {
    this._focusNome.dispose();
    this._focusDescricao.dispose();
    this._focusLocal.dispose();

    super.dispose();
  }

  _save(_ViewModel _viewModel) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Atividade _atividade = Atividade(
          nome: this._nome,
          local: this._local,
          descricao: this._descricao,
          dataHoraInicio: this._dataHoraInicio,
          dataHoraFim: this._dataHoraFim,
          usuario: _viewModel.usuarioLogado.uid);

      _viewModel.adicionar(_atividade);

      Navigator.of(context).pop();
    }
  }

  _buildBody(_ViewModel _viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Atividade"),
      ),
      body: Form(
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
                  this._focusDescricao.requestFocus();
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
                keyboardType: TextInputType.text,
                focusNode: _focusDescricao,
                textInputAction: TextInputAction.next,
                minLines: 2,
                maxLines: 4,
                validator: (descricao) {
                  if (descricao.isEmpty) {
                    return "Informe a descrição";
                  }
                  return null;
                },
                onFieldSubmitted: (nome) {
                  this._focusDescricao.unfocus();
                  this._focusLocal.requestFocus();
                },
                onSaved: (descricao) {
                  this._descricao = descricao;
                },
                decoration: InputDecoration(hintText: "descrição", labelText: "descrição", icon: Icon(Icons.text_fields)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusLocal,
                  validator: (local) {
                    if (local.isEmpty) {
                      return "Informe o local";
                    }
                    return null;
                  },
                  onFieldSubmitted: (nome) {
                    this._focusLocal.unfocus();
                    this._focusDataHoraInicio.requestFocus();
                  },
                  onSaved: (local) {
                    this._local = local;
                  },
                  decoration: InputDecoration(hintText: "local", labelText: "local", icon: Icon(Icons.map))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DateTimeFormField(
                        inputType: Type.date,
                        format: DateFormat("dd/MM/yyyy"),
                        textInputAction: TextInputAction.next,
                        focusNode: _focusDataHoraInicio,
                        style: TextStyle(),
                        validator: (dataHoraInicio) {
                          if (dataHoraInicio == null) {
                            return "Informe a data e hora de início";
                          }
                          return null;
                        },
                        onFieldSubmitted: (nome) {
                          this._focusDataHoraInicio.unfocus();
                          this._focusDataHoraFim.requestFocus();
                        },
                        onSaved: (dataHoraInicio) {
                          this._dataHoraInicio = dataHoraInicio;
                        },
                        inputDecoration: InputDecoration(hintText: "data hora de início", labelText: "data hora de início")),
                  ),
//                  Expanded(
//                    flex: 1,
//                    child: DateTimeFormField(
//                        inputType: Type.time,
//                        format: DateFormat("HH:mm"),
//                        textInputAction: TextInputAction.next,
//                        validator: (dataHoraInicio) {
//                          if (dataHoraInicio == null) {
//                            return "Informe a hora de início";
//                          }
//                          return null;
//                        },
//                        onFieldSubmitted: (nome) {
////                        this._focusDataHoraFim.requestFocus();
//                        },
//                        onSaved: (dataHoraInicio) {
////                        this._dataHoraInicio = dataHoraInicio;
//                        },
//                        inputDecoration: InputDecoration(hintText: "Hora de início", labelText: "hora de início")),
//                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: DateTimeFormField(
                  inputType: Type.both,
                  format: DateFormat("dd/MM/yyyy HH:mm"),
                  textInputAction: TextInputAction.send,
                  focusNode: _focusDataHoraFim,
                  validator: (dataHoraFim) {
                    if (dataHoraFim == null) {
                      return "Informe a data e hora de término";
                    }
                    return null;
                  },
                  onFieldSubmitted: (nome) {
                    this._focusDataHoraFim.unfocus();
                  },
                  onSaved: (dataHoraFim) {
                    this._dataHoraFim = dataHoraFim;
                  },
                  inputDecoration: InputDecoration(hintText: "data hora de término", labelText: "data hora de término")),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
              child: RaisedButton(
                child: Text("Enviar"),
                onPressed: () {
                  this._save(_viewModel);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.create(store),
      builder: (_, _ViewModel _viewModel) => _buildBody(_viewModel),
    );
  }
}

class _ViewModel {
  final Usuario usuarioLogado;
  final Function(Atividade atividade) adicionar;

  _ViewModel({this.usuarioLogado, this.adicionar});

  factory _ViewModel.create(Store<AppState> store) {
    return _ViewModel(
        usuarioLogado: store.state.usuarioState.usuario,
        adicionar: (atividade) {
          store.dispatch(AdicionarAtividadeAction(atividade));
        });
  }
}
