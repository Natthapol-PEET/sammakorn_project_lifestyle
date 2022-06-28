import 'package:dashboard_status_vms_access_control/models/confix_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Confix {
  Database? db;

  Future getDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'confix_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE confixs (id INTEGER PRIMARY KEY, page TEXT)',
        );
      },
      version: 1,
    );
  }

  Future initConfix() async {
    var result = await confixs();

    if (result.isNotEmpty) return;

    var data = const ConfixModel(
      id: 1,
      page: 'entrance',
    );

    insertConfix(data);
  }

  Future<void> insertConfix(ConfixModel confix) async {
    await db!.insert(
      'confixs',
      confix.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ConfixModel>> confixs() async {
    final List<Map<String, dynamic>> maps = await db!.query(
      'confixs',
    );

    return List.generate(maps.length, (i) {
      return ConfixModel(
        id: maps[i]['id'],
        page: maps[i]['page'],
      );
    });
  }

  Future<void> updateConfix(ConfixModel confix) async {
    await db!.update(
      'confixs',
      confix.toMap(),
      where: 'id = ?',
      whereArgs: [confix.id],
    );
  }

  Future<void> deleteConfix(int id) async {
    await db!.delete(
      'confixs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void dropTable() async {
    String sql = "DROP TABLE confixs";
    await db!.execute(sql);
  }

  Future close() async => db!.close();

  void test() async {
    // --------- Test ------------------------
    var data = const ConfixModel(
      id: 1,
      page: 'entrance',
    );

    // insert
    // await insertAccount(peet);
    // print(await accounts());

    // update
    data = const ConfixModel(
      id: 1,
      page: 'exit',
    );
    // await updateAccount(peet);
    // print(await accounts());

    // await deleteAccount(1);
    print(await confixs());

    // --------- End Test --------------------
  }
}
