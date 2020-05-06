import 'package:catolica/actions/usuario_actions.dart';
import 'package:catolica/domain/atividade.dart';
import 'package:catolica/domain/usuario.dart';
import 'package:catolica/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _buildBody(_ViewModel _viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semana TI Católica 2020"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              _viewModel.atividades.length.toString(),
              style: TextStyle(fontSize: 30),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[800]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_viewModel.usuarioLogado.nome, style: TextStyle(color: Colors.white)),
                  Text(_viewModel.usuarioLogado.email, style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            ListTile(
              onTap: () {
                ProgressHUD.of(context).showWithText("Saindo....");
                _viewModel.logout();
              },
              leading: Icon(Icons.exit_to_app),
              title: Text("Sair"),
            )
          ],
        ),
      ),
      floatingActionButton: _getBotaoAcao(_viewModel),
      body: _listaAtividades(_viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {
        ProgressHUD.of(context).dismiss();
      },
      converter: (Store<AppState> store) => _ViewModel.create(store),
      builder: (_, _ViewModel _viewModel) => _buildBody(_viewModel),
    );
  }

  _getBotaoAcao(_ViewModel _viewModel) {
    if (_viewModel.usuarioLogado.admin) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("atividade");
        },
        child: Icon(Icons.add),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  _listaAtividades(_ViewModel _viewModel) {
    if (_viewModel.atividades.isEmpty) {
      return Center(
        child: Text("Sem atividades para exibir"),
      );
    }
    return ListView(
      children: _viewModel.atividades.map((ativade) {
        return Card(
            child: InkWell(
          child: Container(
            height: 370,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                      Container(width: double.maxFinite, height: 150, child: Image.network(ativade.foto, fit: BoxFit.cover)),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Text(ativade.nome, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Text(ativade.descricao, style: TextStyle(color: Colors.black54), overflow: TextOverflow.ellipsis, maxLines: 4),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Text("Início: ${DateFormat("dd/MM/yyyy HH:mm").format(ativade.dataHoraInicio)}",
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Text("Término: ${DateFormat("dd/MM/yyyy HH:mm").format(ativade.dataHoraInicio)}",
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      _viewModel.usuarioLogado.admin
                          ? InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text("Editar"),
                              ),
                            )
                          : SizedBox.shrink(),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text("Avise-me"),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
      }).toList(),
    );
  }
}

class _ViewModel {
  final Usuario usuarioLogado;
  final List<Atividade> atividades;
  final Function() logout;

  _ViewModel({this.usuarioLogado, this.atividades, this.logout});

  factory _ViewModel.create(Store<AppState> store) {
    return _ViewModel(
        usuarioLogado: store.state.usuarioState.usuario,
        atividades: store.state.atividadeState.atividades,
        logout: () {
          store.dispatch(FazerLogout());
        });
  }
}
