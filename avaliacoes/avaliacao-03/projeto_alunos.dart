import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Inicialização da FFI para SQLite em ambiente Dart VM CLI/Desktop
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

  // Define o caminho absoluto para 'alunos.db' na raiz do projeto
  final String dbPath = p.join(Directory.current.path, 'alunos.db');

  Database? db;

  try {
    // 1 e 2) Criar/abrir o banco na raiz do projeto e criar a tabela tb_alunos se o banco não existir
    db = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE tb_alunos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              idade INTEGER NOT NULL,
              curso TEXT NOT NULL
            )
          ''');
          print('Banco de dados e tabela "tb_alunos" criados com sucesso.');
        },
      ),
    );

    // 3) Inserção de três alunos
    await inserindoAlunos(db);

    // 4) Listagem dos dados gravados
    await listarAlunos(db);

  } catch (e) {
    print('Erro durante a inicialização/execução do banco de dados: $e');
  } finally {
    // Fechamento seguro da conexão
    if (db != null) {
      try {
        await db.close();
        print('Conexão com o banco de dados encerrada.');
      } catch (e) {
        print('Erro ao fechar a conexão com o banco de dados: $e');
      }
    }
  }
}

// Função assíncrona com tratamento de exceção para inserção de registros
Future<void> inserindoAlunos(Database db) async {
  try {
    final List<Map<String, dynamic>> novosAlunos = [
      {'nome': 'Ana Silva', 'idade': 20, 'curso': 'Engenharia'},
      {'nome': 'Bruno Souza', 'idade': 22, 'curso': 'Ciência da Computação'},
      {'nome': 'Carla Dias', 'idade': 21, 'curso': 'Matemática'},
    ];

    for (var aluno in novosAlunos) {
      int id = await db.insert('tb_alunos', aluno);
      print('Aluno inserido com sucesso (ID: $id): ${aluno['nome']}');
    }
  } catch (e) {
    print('Erro ao inserir registros na tabela "tb_alunos": $e');
  }
}

// Função assíncrona com tratamento de exceção para consulta de registros
Future<void> listarAlunos(Database db) async {
  try {
    print('\n--- Listagem da tabela tb_alunos ---');
    final List<Map<String, dynamic>> registros = await db.query('tb_alunos');

    if (registros.isEmpty) {
      print('Nenhum registro encontrado.');
    } else {
      for (var linha in registros) {
        print('ID: ${linha['id']} | Nome: ${linha['nome']} | Idade: ${linha['idade']} | Curso: ${linha['curso']}');
      }
    }
    print('------------------------------------\n');
  } catch (e) {
    print('Erro ao realizar a leitura da tabela "tb_alunos": $e');
  }
}