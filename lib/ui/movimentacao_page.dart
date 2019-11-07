import 'package:flutter/material.dart';
import 'package:my_coin_flutter_app/helpers/movimentacao_helper.dart';

class MovimentacaoPage extends StatefulWidget {
  final Movimentacao movimentacao;

  MovimentacaoPage({this.movimentacao});

  @override
  _MovimentacaoPageState createState() => _MovimentacaoPageState();
}

class _MovimentacaoPageState extends State<MovimentacaoPage> {
  final _tituloController = TextEditingController();
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();

  final _tituloFocus = FocusNode();

  bool _movimentacaoEdited = false;

  Movimentacao _editedMovimentacao;

  @override
  void initState() {
    super.initState();

    if (widget.movimentacao == null) {
      _editedMovimentacao = Movimentacao();
    } else {
      _editedMovimentacao = Movimentacao.fromMap(widget.movimentacao.toMap());

      //quando passar uma movimentação editar os dados
      _tituloController.text = _editedMovimentacao.titulo;
      _valorController.text = _editedMovimentacao.valor;
      _dataController.text = _editedMovimentacao.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //quando der um pop chama uma função
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(_editedMovimentacao.titulo ?? "Movimentação nova"),
          centerTitle: true,
        ),
        //Salvar
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedMovimentacao.valor != null && _editedMovimentacao.valor.isNotEmpty) {
              Navigator.pop(context,
                  _editedMovimentacao); //elima a tela da pilha e passa para tela anterior da movimentação editado
            } else {
              FocusScope.of(context).requestFocus(_tituloFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _tituloController,
                focusNode: _tituloFocus, //para controlar o focu do nome
                decoration: InputDecoration(labelText: "Ex.: Salário"),
                onChanged: (text) {
                  _movimentacaoEdited = true;
                  setState(() {
                    _editedMovimentacao.titulo = text;
                  });
                },
              ),
              TextField(
                controller: _valorController,
                decoration: InputDecoration(labelText: "Valor"),
                onChanged: (text) {
                  _movimentacaoEdited = true;
                  _editedMovimentacao.valor = text;
                },
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _dataController,
                decoration: InputDecoration(labelText: "Data"),
                onChanged: (text) {
                  _movimentacaoEdited = true;
                  _editedMovimentacao.data = text;
                },
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_movimentacaoEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Ao sair você perderá as alterações."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

}
