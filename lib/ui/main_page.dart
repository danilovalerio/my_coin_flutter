import 'package:flutter/material.dart';
import 'package:my_coin_flutter_app/helpers/movimentacao_helper.dart';

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
        onPressed: () {},
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
                      Text(
                        movimentacoes[index].titulo ?? "",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "R\$ "+movimentacoes[index].valor ?? "",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
//                      Text(
//                        movimentacoes[index].data ?? "",
//                        style: TextStyle(fontSize: 18),
//                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        movimentacoes[index].descricao ?? "",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        movimentacoes[index].data ?? "",
                        style: TextStyle(fontSize: 18),
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
//        _showContactPage(contact: contacts[index]);
      },
    );
  }

  void _getAllMovimentacoes() {
    helper.getAllMovimentacoes().then((list) {
      setState(() {
        movimentacoes = list;
      });
    });
  }
}
