import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String movimentacaoTable = "movimentacaoTable";
final String idColumn = "idColumn";
final String tipoColumn = "tipoColumn";
final String valorColumn = "valorColumn";
final String dataColumn = "dataColumn";
final String tituloColumn = "tituloColumn";
final String descricaoColumn = "descricaoColumn";
final String usuarioIdColumn = "usuarioIdColumn";
final String caixaIdColumn = "caixaIdColumn";

//Auxilia com a entidade movimentacao no banco
class MovimentacaoHelper {
  //singletone
  static final MovimentacaoHelper _instance = MovimentacaoHelper.internal();

  factory MovimentacaoHelper() => _instance;

  MovimentacaoHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "mycoin.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute("CREATE TABLE $movimentacaoTable("
          "$idColumn INTEGER PRIMARY KEY, "
          "$tipoColumn TEXT, "
          "$valorColumn TEXT,"
          "$dataColumn TEXT, "
          "$tituloColumn TEXT, "
          "$descricaoColumn TEXT, "
          "$usuarioIdColumn INTEGER, "
          "$caixaIdColumn INTEGER)");
    });
  }

  //Retorna uma movimentação no futuro por vir do banco
  Future<Movimentacao> saveMovimentacao(Movimentacao movimentacao) async {
    Database dbMyCoin = await db;
    movimentacao.id = await dbMyCoin.insert(movimentacaoTable,
        movimentacao.toMap()); //convert usuário para map para salvar no banco
    return movimentacao;
  }

  //Busca movimentacao pelo id
  Future<Movimentacao> getMovimentacao(int id) async {
    Database dbMyCoint = await db;
    List<Map> maps = await dbMyCoint.query(movimentacaoTable,
        columns: [
          idColumn,
          tipoColumn,
          valorColumn,
          dataColumn,
          tipoColumn,
          descricaoColumn,
          usuarioIdColumn,
          caixaIdColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Movimentacao.fromMap(maps.first);
    } else {
      return null;
    }
  }

  //Deletar um contato que retorna um inteiro
  Future<int> deleteMovimentacao(int id) async {
    Database dbMyCoin = await db;
    return await dbMyCoin
        .delete(movimentacaoTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateMovimentcao(Movimentacao movimentacao) async {
    Database dbMyCoin = await db;
    return await dbMyCoin.update(movimentacaoTable, movimentacao.toMap(),
        where: "$idColumn = ?", whereArgs: [movimentacao.id]);
  }

  //retorna todas as movimentacoes
  Future<List> getAllMovimentacoes() async {
    Database dbMyCoin = await db;
    List listMap = await dbMyCoin.rawQuery("SELECT * FROM $movimentacaoTable");
    List<Movimentacao> listMovimentacoes = List();

    //para cada map na minha lista
    for (Map m in listMap) {
      //para cada map convert em contact e adiciona na lista de contacts
      listMovimentacoes.add(Movimentacao.fromMap(m));
    }
    return listMovimentacoes;
  }

  //retorna a quantidade de movimentações realizadas
  Future<int> getNumber() async {
    Database dbMyCoin = await db;
    String sql = "SELECT COUNT(*) FROM $movimentacaoTable)";
    return Sqflite.firstIntValue(await dbMyCoin.rawQuery(sql));
  }

  Future close() async {
    Database dbMyCoin = await db;
    dbMyCoin.close();
  }
}

//Model movimentacao
class Movimentacao {
  int id;
  String tipo;
  String valor;
  String data;
  String titulo;
  String descricao;
  int usuarioId;
  int caixaId;

  Movimentacao();

  //pega o map
  Movimentacao.fromMap(Map map) {
    id = map[idColumn];
    tipo = map[tipoColumn];
    valor = map[valorColumn];
    data = map[dataColumn];
    titulo = map[tituloColumn];
    descricao = map[descricaoColumn];
    usuarioId = map[usuarioIdColumn];
    caixaId = map[caixaIdColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      tipoColumn: tipo,
      valorColumn: valor,
      dataColumn: data,
      tituloColumn: titulo,
      descricaoColumn: descricao,
      usuarioIdColumn: usuarioId,
      caixaIdColumn: caixaId
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Movimentacao: id: $id, tipo: $tipo, valor: $valor, data: $data, titulo: $titulo, descricao: $descricao, usuarioId: $usuarioId, caixaId: $caixaId)";
  }
}
