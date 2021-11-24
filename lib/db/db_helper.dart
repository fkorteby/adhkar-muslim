import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/model.dart';

class DbHelper {
  static Database _db;
  static const String id = 'id';
  static const String name = 'name';
  static const String page = 'page';
  static const String TABLE = 'Favorite';
  static const String DB_NAME = 'adhkar.db';

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($id INTEGER PRIMARY KEY AUTOINCREMENT, $name TEXT, $page INTEGER)");
  }

  Future<Model> save(Model model) async {
    var dbClient = await db;
    model.id = await dbClient.insert(TABLE, model.toMap());
    return model;
  }

  Future<List<Model>> getAllFavoritesModels() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [id, name, page]);
    List<Model> models = [];
    if (maps.length > 0) {
      for (var map in maps) {
        models.add(Model.fromMap(map));
      }
    }
    return models;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Model model) async {
    var dbClient = await db;
    return await dbClient
        .update(TABLE, model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
