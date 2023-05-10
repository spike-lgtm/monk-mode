import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _databaseName = "launcher.db";
  static const int _databaseVersion = 1;

  static const String favApps = "fav_apps";
  static const String appContext = "app_context";

  DBHelper._constructor();
  static final DBHelper instance = DBHelper._constructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/$_databaseName';

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $appContext (
      id INTEGER PRIMARY KEY,
      header TEXT NOT NULL,
      focus INTEGER NOT NULL,
      fav_app_size INTEGER NOT NULL,
      normal_app_size INTEGER NOT NULL
    );    
  ''');
    await db.execute('''
    INSERT INTO $appContext(id, header, focus, fav_app_size, normal_app_size) 
    VALUES (0, "Think in decades, act in days...", 0, 24, 28);
  ''');

    await db.execute('''
    CREATE TABLE $favApps (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        package_name TEXT NOT NULL
    );  ''');
  }
}

class DbService {
  String dbName;
  DbService({required this.dbName});

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await DBHelper.instance.database;
    return await db.insert(dbName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await DBHelper.instance.database;
    return await db.query(dbName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await DBHelper.instance.database;
    int id = row['id'];
    row.remove('id');
    return await db.update(dbName, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await DBHelper.instance.database;
    return await db.delete(dbName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteViaCustomRow(String rowName, dynamic argument) async {
    Database db = await DBHelper.instance.database;
    return await db
        .delete(dbName, where: '$rowName = ?', whereArgs: [argument]);
  }
}
