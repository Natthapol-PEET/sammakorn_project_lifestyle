import 'dart:async';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

class SQLite {
  final String _createSQL;
  SQLite(this._createSQL);

  final _databaseName = 'db.db';
  final _databaseVersion = 1;

  String createSQLcommand;
  String databasePath;
  String dbPath;
  Database _database;

  void OpenOrCreate() async {
    createSQLcommand = _createSQL;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
  }

  Future<void> createDatabase(Database db, int version) async {
    if (createSQLcommand != "") {
      await db.execute(createSQLcommand);
    }
  }

  Future<List<Map<String, dynamic>>> queryDatabase(String sqlString) async {
    createSQLcommand = _createSQL;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawQuery(sqlString);
  }

  Future<int> insertDatabase(String sqlString) async {
    createSQLcommand = _createSQL;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawInsert(sqlString);
  }

  Future<int> updateDatabase(String sqlString) async {
    createSQLcommand = _createSQL;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawUpdate(sqlString);
  }

  Future<int> deleteDatabase(String sqlString) async {
    createSQLcommand = _createSQL;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawDelete(sqlString);
  }

  void closeDatabase(String sqlString) async {
    createSQLcommand = _createSQL;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    await _database.close();
  }
}
