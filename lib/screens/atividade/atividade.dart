import 'package:catolica/service/atividade_service.dart';
import 'package:catolica/service/usuario_service.dart';
import 'package:catolica/widgets/form/date_time_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AtividadeScreen extends StatefulWidget {
  @override
  AtividadeScreenState createState() => AtividadeScreenState();
}

class AtividadeScreenState extends State<AtividadeScreen> {
  final _formKey = GlobalKey<FormState>();
  UsuarioService _usuarioService;
  AtividadeService _atividadeService;

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

  _save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //todo: invocar o atividade service para salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    _usuarioService = Provider.of<UsuarioService>(context);
    _atividadeService = Provider.of<AtividadeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Atividade"),
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
                  child: DateTimeFormField(
                      inputType: Type.both,
                      format: DateFormat("dd/MM/yyyy HH:mm"),
                      textInputAction: TextInputAction.next,
                      focusNode: _focusDataHoraInicio,
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
                      this._save();
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
}
