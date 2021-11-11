import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class contatohelper {
  //contatohelper _databaseHelper = contatohelper();
  late Database _database;

//Atributos da tabela e banco de dados (Nome da tabela e coluna)

  final String contatoTable = "contato";
  final String idColumn = "id";
  final String nomeColumn = "nome";
  final String emailColumn = "email";
  final String telefoneColumn = "telefone";
  final String imagemColumn = "imagem";

  contatohelper._createInstance();

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
    Database db = await database;
    var result = await db.rawQuery("SELECT * FROM $contatoTable");

    return result;
  }

  Future<int> inserirContato(Contato contato) async {
    Database db = await database;
    var result = await db.insert(contatoTable, contato.toMap());
    return result;
  }

  Future<int> atualizarContato(Contato contato) async {
    var db = await database;
    var result = await db.rawUpdate(
        "UPDATE $contatoTable SET $nomeColumn = '${contato._nome}', $emailColumn = '${contato._email}', $telefoneColumn = '${contato._telefone}', $imagemColumn = '${contato._imagem}'   WHERE $idColumn = '${contato._id}'");
    return result;
  }

  Future<int> apagarContato(int id) async {
    var db = await database;
    int result =
        await db.rawDelete('DELETE FROM $contatoTable WHERE $idColumn = $id');
    return result;
  }

  Future<List<Contato>> getListaDeContato() async {
    //Contato contato = new Contato(0, "", "", "", "");
    var contatoMapList = await getContatoMapList();
    int count = contatoMapList.length;
    List<Contato> listaDeContatos = <Contato>[];
    for (int i = 0; i < count; i++) {
      listaDeContatos.add(Contato.fromMap(contatoMapList[i]));
    }
    return listaDeContatos;
  }
}

class Contato {
  int _id = 0;
  String _nome = "";
  String _email = "";
  String _telefone = "";
  String _imagem = "";

  //Contato(this._id, this._nome, this._email, this._telefone, this._imagem);
  Contato();

  int get id => id;
  String get nome => _nome;
  String get email => _email;
  String get telefone => _telefone;
  String get imagem => _imagem;

  setImagem(String imagem){
    _imagem = imagem;
  }

  setNome(String nome){
    _nome = nome;
  }

  setEmail(String email){
    _email = email;
  }

  setTelefone(String telefone){
    _telefone = telefone;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['nome'] = _nome;
    map['email'] = _email;
    map['telefone'] = _telefone;
    map['imagem'] = _imagem;
    return map;
  }


  Contato.fromMap(Map<String, dynamic> map) {
    _email = map['email'];
    _imagem = map['imagem'];
    _nome = map['nome'];
    _telefone = map['telefone'];
    _id = map['id'];
  }

  @override
  String toString() {
    return "Contact(id: $_id, name: $_nome, email: $_email, phone: $_telefone, img: $_imagem)";
  }
}
