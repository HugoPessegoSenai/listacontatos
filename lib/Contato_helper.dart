import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Atributos da tabela e banco de dados (Nome da tabela e coluna)

final String contatoTable = "contatoTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String telefoneColumn = "telefoneColumn";
final String imagemColumn = "imagemColumn";

class ContatoHelper {
  static final ContatoHelper _instance = ContatoHelper.internal();

  factory ContatoHelper() => _instance;

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
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contato.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newversion) async {
      await db.execute(
          "CREATE TABLE $contatoTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT," +
              " $emailColumn TEXT, $telefoneColumn TEXT, $imagemColumn TEXT)");
    });
  }

  Future<Contato> saveContato(Contato contato)async{
    Database dbContato = await db;
    contato.id = await dbContato.insert(contatoTable, contato.toMap());
    return contato;
  }
}

class Contato {
  int id;
  String nome;
  String email;
  String telefone;
  String imagem;

  Contato();

  Map toMap(){
    Map<String,dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      telefoneColumn: telefone,
      imagemColumn: imagem
    };

    if(id!=null){
      map[idColumn] = id;
    }
    return map;
  }
  
}

