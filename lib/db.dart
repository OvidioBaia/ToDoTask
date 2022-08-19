import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'package:tasktodo/task_model.dart';

class Conection {

  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'atividades.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate );
    return db;
  }

  _onCreate(Database db, int version) async {
    await  db.execute(
      "CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT NOT NULL,descricao TEXT NOT NULL, duracao TEXT NOT NULL, data TEXT  NOT NULL)",
    );
  }


  Future<Task> insert(Task task) async {
    var dbClient = await db;
    await dbClient!.insert('tasks', task.toMap());
    return task;
  }

  Future<List<Task>> list() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult  = await dbClient!.query('tasks');
    return queryResult.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getById(id) async{
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.rawQuery('SELECT * FROM tasks WHERE id=?', [id]);
    return queryResult.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getCartListWithUserId() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult = await dbClient!.query('tasks' );
    return queryResult.map((e) => Task.fromMap(e)).toList();

  }



  Future deleteTableContent() async {
    var dbClient = await db;
    return await dbClient!.delete(
      'tasks',
    );
  }


  Future<int> updateQuantity(Task task) async {
    var dbClient = await db;
    return await dbClient!.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }


}