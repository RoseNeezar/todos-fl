import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todos/models/todo.model.dart';

class DatabaseService {
  static const DatabaseService instance = DatabaseService._();

  const DatabaseService._();

  static const String _todoTable = 'todos_table';
  static const String _colId = 'id';
  static const String _colName = 'name';
  static const String _colDate = 'date';
  static const String _colPriorityLevel = 'priority_level';
  static const String _colCompleted = 'completed';

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dir = await getApplicationSupportDirectory();
    final path = dir.path + '/todo_list.db';
    final todoListDB = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(''' 
        CREATE TABLE $_todoTable (
          $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_colName TEXT,
          $_colDate TEXT,
          $_colPriorityLevel TEXT,
          $_colCompleted INTEGER
        ) 
        ''');
    });
    return todoListDB;
  }

  Future<Todo> insert(Todo todo) async {
    final db = await this.db;
    final id = await db.insert(_todoTable, todo.toMap());
    final todoWithId = todo.copyWith(id: id);
    return todoWithId;
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await this.db;
    final todosData = await db.query(_todoTable, orderBy: '$_colDate DESC');
    return todosData.map((e) => Todo.fromMap(e)).toList();
  }

  Future<int> update(Todo todo) async {
    final db = await this.db;
    return await db.update(_todoTable, todo.toMap(),
        where: '$_colId = ?', whereArgs: [todo.id]);
  }

  Future<int> delete(int id) async {
    final db = await this.db;
    return await db.delete(_todoTable, where: '$_colId = ?', whereArgs: [id]);
  }
}
