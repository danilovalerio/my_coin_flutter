import 'package:flutter/material.dart';
import 'package:my_coin_flutter_app/helpers/movimentacao_helper.dart';
import 'package:my_coin_flutter_app/ui/movimentacao_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MovimentacaoHelper helper = MovimentacaoHelper();
  List<Movimentacao> movimentacoes = List();

  //teste do banco de dados
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    Movimentacao m = Movimentacao();
//    m.tipo = "d";
//    m.caixaId = 1;
//    m.usuarioId = 1;
//    m.data = "10/10/2019";
//    m.valor = "30";
//    m.titulo = "Salário";
//    m.descricao = "Salário mensal";
//
//    helper.saveMovimentacao(m);
//
//    helper.getAllMovimentacoes().then((list) {
//      print(list);
//    });

    _getAllMovimentacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Coin"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMovimentacaoPage();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: movimentacoes.length,
        itemBuilder: (context, index) {
          return _movimentacaoCard(context, index);
        },
      ),
    );
  }

  Widget _movimentacaoCard(BuildContext context, int index) {
    //como card não tem toque adicionamos um gesture
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          movimentacoes[index].titulo ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          movimentacoes[index].data ?? "",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14,
                          fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          movimentacoes[index].descricao ?? "",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "R\$ "+movimentacoes[index].valor ?? "",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        //_showMovimentacaoPage(movimentacao: movimentacoes[index]);
        //_showOptions(context, index);
        _showOptionsAlert(context, index);
      },
    );
  }

  void _showOptionsAlert(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
//            title: Text("Editar"),
            titlePadding: EdgeInsets.all(15),
            titleTextStyle: TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
//            content: Text( "descricao" ),
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.9),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Editar",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showMovimentacaoPage(
                      movimentacao: movimentacoes[index]);
                },
              ),
              FlatButton(
                child: Text(
                  "Excluir",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                onPressed: () {
                  helper.deleteMovimentacao(movimentacoes[index].id);
                  setState(() {
                    movimentacoes.removeAt(index);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showMovimentacaoPage(
                              movimentacao: movimentacoes[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        onPressed: () {
                          helper.deleteMovimentacao(movimentacoes[index].id);
                          setState(() {
                            movimentacoes.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showMovimentacaoPage({Movimentacao movimentacao}) async {
    final recebeMovimentacao = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MovimentacaoPage(
                  movimentacao: movimentacao,
                )));
    if (recebeMovimentacao != null) {
      if (movimentacao != null) {
        await helper.updateMovimentcao(recebeMovimentacao);
      } else {
        await helper.saveMovimentacao(recebeMovimentacao);
      }
      _getAllMovimentacoes();
    }
  }

  void _getAllMovimentacoes() {
    helper.getAllMovimentacoes().then((list) {
      setState(() {
        movimentacoes = list;
      });
    });
  }
}
