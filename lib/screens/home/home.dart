import 'package:cached_network_image/cached_network_image.dart';
import 'package:catolica/domain/atividade.dart';
import 'package:catolica/screens/profile/edit.dart';
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
  AtividadeService _atividadeService;
  UsuarioService _usuarioService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _usuarioService = Provider.of<UsuarioService>(context);
    _atividadeService = Provider.of<AtividadeService>(context);

    _atividadeService.carregarAtividades();

    return Scaffold(
      appBar: AppBar(
        title: Text("Semana TI Católica 2020"),
        actions: [
          Observer(
            builder: (ctx) =>
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    _atividadeService.atividadeStore.quantidadeAtividades.toString(),
                    style: TextStyle(fontSize: 30),
                  ),
                ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[800]),
              child: Observer(
                builder: (ctx) =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        this._usuarioService.usuarioStore.usuario.foto != null
                            ? CachedNetworkImage(
                          imageUrl: this._usuarioService.usuarioStore.usuario.foto,
                          imageBuilder: (_, imageProvider) {
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50), image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
                            );
                          },
                        )
                            : Container(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.person, size: 40),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(this._usuarioService.usuarioStore.usuario.nome, style: TextStyle(color: Colors.white)),
                                  Text(this._usuarioService.usuarioStore.usuario.email, style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (_) => EditProfileScreen(usuario: this._usuarioService.usuarioStore.usuario)));
                                },
                              )
                            ],
                          ),
                        )
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
      floatingActionButton: Observer(
        builder: (ctx) {
          if (_usuarioService.usuarioStore.usuario.admin) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed("atividade");
              },
              child: Icon(Icons.add),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
      body: _listarAtividadesStream(),
    );
  }

  _listarAtividadesFuture() {
    return FutureBuilder(
      future: _atividadeService.carregarAtividades(),
      builder: (context, AsyncSnapshot<List<Atividade>> snp) {
        if (!snp.hasData) {
          return Center(
            child: Text("Carregando..."),
          );
        }

        if (snp.hasError) {
          return Center(
            child: Text("Erro ao carregar atividades..."),
          );
        }

        return renderList(snp.data);
      },
    );
  }

  _listarAtividadesStream() {
    return StreamBuilder(
      stream: _atividadeService.atividadesStream(),
      builder: (context, AsyncSnapshot<List<Atividade>> snp) {
        if (!snp.hasData) {
          return Center(
            child: Text("Carregando..."),
          );
        }

        if (snp.hasError) {
          return Center(
            child: Text("Erro ao carregar atividades..."),
          );
        }

        return renderList(snp.data);
      },
    );
  }

  _listaAtividades() {
    return Observer(
      builder: (ctx) {
        if (_atividadeService.atividadeStore.atividades.isEmpty) {
          return Center(
            child: Text("Sem atividades para exibir"),
          );
        }

        return renderList(_atividadeService.atividadeStore.atividades.values.toList());
      },
    );
  }

  renderList(List<Atividade> atividades) {

    atividades.sort((a1, a2) => a1.dataHoraInicio.compareTo(a2.dataHoraInicio));

    return ListView(
      padding: EdgeInsets.only(bottom: 50),
      children: atividades.map((ativade) {
        return Card(
            child: InkWell(
              child: Container(
                height: 200,
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
                    ativade.dataHoraFim != null
                        ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      child: Text("Término: ${DateFormat("dd/MM/yyyy HH:mm").format(ativade.dataHoraFim)}",
                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    )
                        : SizedBox.shrink(),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Observer(
                            builder: (ctx) {
                              if (_usuarioService.usuarioStore.usuario.admin) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("atividade", arguments: ativade);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text("Editar"),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            },
                          ),
                          ativade.avisar.contains(_usuarioService.usuarioStore.usuario.uid) ?
                          InkWell(
                            onTap: () {
                              _atividadeService.toogleAvisar(ativade, _usuarioService.usuarioStore.usuario.uid);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text("Não avisar", style: TextStyle(color: Colors.deepOrange)),
                            ),
                          )
                              :
                          InkWell(
                            onTap: () {
                              _atividadeService.toogleAvisar(ativade, _usuarioService.usuarioStore.usuario.uid);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text("Avise-me", style: TextStyle(color: Colors.green)),
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
