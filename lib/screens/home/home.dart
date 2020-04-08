import 'package:catolica/domain/atividade.dart';
import 'package:catolica/service/atividade_service.dart';
import 'package:catolica/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AtividadeService _atividadeService = new AtividadeService();

  UsuarioService _usuarioService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _usuarioService = Provider.of<UsuarioService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Semana TI Católica 2020"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[800]),
              child: Observer(
                builder: (ctx) => Column(
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
                    Text(this._usuarioService.usuarioStore.usuario.nome, style: TextStyle(color: Colors.white)),
                    Text(this._usuarioService.usuarioStore.usuario.email, style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {
                _usuarioService.logout();
              },
              leading: Icon(Icons.exit_to_app),
              title: Text("Sair"),
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: _atividadeService.buscarAtividades(),
        builder: (context, AsyncSnapshot<List<Atividade>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Carregando...."),
            );
          }

          return ListView(
            children: snapshot.data.map((ativade) {
              return Card(
                  child: InkWell(
                child: Container(
                  height: 370,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(width: double.maxFinite, height: 150, child: Image.network(ativade.foto, fit: BoxFit.cover)),
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
        },
      ),
    );
  }
}
