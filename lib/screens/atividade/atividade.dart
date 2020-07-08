import 'package:catolica/domain/atividade.dart';
import 'package:catolica/service/atividade_service.dart';
import 'package:catolica/service/usuario_service.dart';
import 'package:catolica/utils/message_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AtividadeScreen extends StatefulWidget {
  const AtividadeScreen({Key key}) : super(key: key);

  @override
  AtividadeScreenState createState() => AtividadeScreenState();
}

class AtividadeScreenState extends State<AtividadeScreen> {
  final _formKey = GlobalKey<FormState>();
  UsuarioService _usuarioService;
  AtividadeService _atividadeService;

  Atividade _atividadeEdicao;

  String _nome;
  String _descricao;
  String _local;
  DateTime _dataHoraInicio;
  DateTime _dataHoraFim;

  FocusNode _focusNome;
  FocusNode _focusDescricao;
  FocusNode _focusLocal;
  FocusNode _focusDataHoraInicio;
  MaskedTextController _maskDataInicio;
  FocusNode _focusDataHoraFim;
  MaskedTextController _maskDataFim;

  @override
  void initState() {
    super.initState();

    this._focusNome = FocusNode();
    this._focusDescricao = FocusNode();
    this._focusLocal = FocusNode();
    this._focusDataHoraInicio = FocusNode();
    this._maskDataInicio = MaskedTextController(mask: "00/00/0000 00:00");
    this._focusDataHoraFim = FocusNode();
    this._maskDataFim = MaskedTextController(mask: "00/00/0000 00:00");
  }

  @override
  void dispose() {
    this._focusNome.dispose();
    this._focusDescricao.dispose();
    this._focusLocal.dispose();
    this._maskDataInicio.dispose();
    this._maskDataFim.dispose();

    super.dispose();
  }

  _save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Atividade atividade = Atividade(
          id: _atividadeEdicao?.id,
          nome: this._nome,
          local: this._local,
          descricao: this._descricao,
          dataHoraInicio: this._dataHoraInicio,
          dataHoraFim: this._dataHoraFim,
          usuario: this._usuarioService.usuarioStore.usuario.uid);

      this._atividadeService.salvar(atividade).then((value) {
        showInfo("Atividade adicionada");
        Navigator.of(context).pop();
      });
    }
  }

  Future<DateTime> _getDataHora() async {
    final dataSelecionada = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));

    if (dataSelecionada != null) {
      final horaSelecionada = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (dataSelecionada != null && horaSelecionada != null) {
        return DateTime(dataSelecionada.year, dataSelecionada.month, dataSelecionada.day, horaSelecionada.hour, horaSelecionada.minute);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    _atividadeEdicao = ModalRoute.of(context).settings.arguments;

    if (_atividadeEdicao?.dataHoraInicio != null) {
      _maskDataInicio.updateText(DateFormat("dd/MM/yyyy HH:mm").format(_atividadeEdicao.dataHoraInicio));
    }

    if (_atividadeEdicao?.dataHoraFim != null) {
      _maskDataFim.updateText(DateFormat("dd/MM/yyyy HH:mm").format(_atividadeEdicao.dataHoraFim));
    }

    _usuarioService = Provider.of<UsuarioService>(context);
    _atividadeService = Provider.of<AtividadeService>(context);

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
                initialValue: _atividadeEdicao?.nome,
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
                initialValue: _atividadeEdicao?.descricao,
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
                  initialValue: _atividadeEdicao?.local,
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
              child: TextFormField(
                  controller: _maskDataInicio,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusDataHoraInicio,
                  validator: (dataHoraStr) {
                    if (dataHoraStr.isEmpty) {
                      return "Informe a data e hora da atividade";
                    } else {
                      try {
                        DateFormat("dd/MM/yyyy HH:mm").parse(dataHoraStr);
                      } catch (e) {
                        return "Data e hora no formato inválido";
                      }
                    }
                    return null;
                  },
                  onFieldSubmitted: (nome) {
                    this._focusDataHoraInicio.unfocus();
                    this._focusDataHoraFim.requestFocus();
                  },
                  onSaved: (dataHoraInicio) {
                    this._dataHoraInicio = DateFormat("dd/MM/yyyy HH:mm").parse(dataHoraInicio);
                  },
                  decoration: InputDecoration(
                      hintText: "Data de Início",
                      labelText: "Data de Início",
                      icon: Icon(Icons.calendar_today),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final DateTime dataSelecionada = await _getDataHora();
                          if (dataSelecionada != null) {
                            _maskDataInicio.updateText(DateFormat("dd/MM/yyyy HH:mm").format(dataSelecionada));
                            this._focusDataHoraInicio.unfocus();
                            this._focusDataHoraFim.requestFocus();
                          }
                        },
                        icon: Icon(FontAwesomeIcons.calendarPlus),
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: TextFormField(
                  controller: _maskDataFim,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusDataHoraFim,
                  validator: (dataHoraStr) {
                    if (dataHoraStr.isEmpty) {
                      return "Informe a data e hora da atividade";
                    } else {
                      try {
                        DateFormat("dd/MM/yyyy HH:mm").parse(dataHoraStr);
                      } catch (e) {
                        return "Data e hora no formato inválido";
                      }
                    }
                    return null;
                  },
                  onFieldSubmitted: (nome) {
                    this._focusDataHoraFim.unfocus();
                  },
                  onSaved: (dataHoraFim) {
                    this._dataHoraFim = DateFormat("dd/MM/yyyy HH:mm").parse(dataHoraFim);
                  },
                  decoration: InputDecoration(
                      hintText: "Data/Hora final",
                      labelText: "Data/Hora final",
                      icon: Icon(Icons.calendar_today),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final DateTime dataSelecionada = await _getDataHora();
                          if (dataSelecionada != null) {
                            _maskDataFim.updateText(DateFormat("dd/MM/yyyy HH:mm").format(dataSelecionada));
                            this._focusDataHoraFim.unfocus();
                          }
                        },
                        icon: Icon(FontAwesomeIcons.calendarPlus),
                      ))),
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
    );
  }
}
