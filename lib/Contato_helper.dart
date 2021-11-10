import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContatoHelper {
  static ContatoHelper _databaseHelper = new ContatoHelper();
  static Database _database = new Database();

//Atributos da tabela e banco de dados (Nome da tabela e coluna)

  final String contatoTable = "contatoTable";
  final String idColumn = "idColumn";
  final String nomeColumn = "nomeColumn";
  final String emailColumn = "emailColumn";
  final String telefoneColumn = "telefoneColumn";
  final String imagemColumn = "imagemColumn";

  ContatoHelper._createInstance();

  factory ContatoHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = ContatoHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await inicializaBanco();
    }

    return _database;
  }

  Future<Database> inicializaBanco() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contatos.db');

    var bandoDeContatos =
        await openDatabase(path, version: 1, onCreate: _criaBanco);
    return bandoDeContatos;
  }

  void _criaBanco(Database db, int versao) async {
    await db.execute(
        "CREATE TABLE $contatoTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT," +
            " $emailColumn TEXT, $telefoneColumn TEXT, $imagemColumn TEXT)");

/*
De uma forma direta, esse seria o SQL
CREATE TABLE tabela_contato(
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome TEXT,
email TEXT
);
*/
  }

  Future<List<Map<String, dynamic>>> getContatoMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery("SELECT * FROM tabela_contato");
    return result;
  }

  Future<int> inserirContato(Contato contato) async {
    Database db = await this.database;
    var result = await db.insert(contatoTable, contato.toMap());
    return result;
  }

  Future<int> atualizarContato(Contato contato, int id) async {
    var db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE $contatoTable SET $nomeColumn = '${contato.nome}', $emailColumn = '${contato.email}', $telefoneColumn = '${contato.telefone}', $imagemColumn = '${contato.imagem}'   WHERE $idColumn = '$id'");
    return result;
  }

  Future<int> apagarContato(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $contatoTable WHERE $idColumn = $id');
    return result;
  }

  Future<List<Contato>> getListaDeContato() async {
    var contatoMapList = await getContatoMapList();
    int count = contatoMapList.length;
    List<Contato> listaDeContatos = List.generate<Contato>();
    for (int i = 0; i < count; i++) {
      listaDeContatos.add(Contato.fromMapObject(contatoMapList[i]));
    }
    return listaDeContatos;
  }
}

class Contato {
  int id;
  String nome;
  String email;
  String telefone;
  String imagem;

  Contato(this.id,this.nome, this.email, this.telefone, this.imagem);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['nome'] = nome;
    map['email'] = email;
    map['telefone'] = telefone;
    map['imagem'] = imagem;
    return map;
  }

  Contato.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nome = map['nome'];
    this.email = map['email'];
    this.telefone = map['telefone'];
    this.imagem = map['imagem'];
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $nome, email: $email, phone: $telefone, img: $imagem)";
  }
}
