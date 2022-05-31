import 'package:path/path.dart';
import 'package:registerapp_flutter/models/account_model.dart';
import 'package:sqflite/sqflite.dart';

class Account {
  Database db;

  Future getDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'accounts_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE accounts(id INTEGER PRIMARY KEY, username TEXT, password TEXT, isLogin INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future initAccount() async {
    // final db = await getDatabase();
    var result = await accounts();

    print('result.isNotEmpty: ${result.isNotEmpty}');

    if (result.isNotEmpty) {
      return;
    }

    var data = const AccountModel(
      id: 1,
      username: '',
      password: '',
      isLogin: 0,
    );

    await db.insert(
      'accounts',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAccount(AccountModel account) async {
    // final db = await getDatabase();

    await db.insert(
      'accounts',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AccountModel>> accounts() async {
    // final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      'accounts',
    );

    return List.generate(maps.length, (i) {
      return AccountModel(
        id: maps[i]['id'],
        username: maps[i]['username'],
        password: maps[i]['password'],
        isLogin: maps[i]['isLogin'],
      );
    });
  }

  Future<void> updateAccount(AccountModel account) async {
    // final db = await getDatabase();

    await db.update(
      'accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<void> deleteAccount(int id) async {
    // final db = await getDatabase();

    await db.delete(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void dropTable() async {
    String sql = "DROP TABLE accounts";
    // final db = await getDatabase();

    await db.execute(sql);
  }

  Future close() async => db.close();

  void test() async {
    // --------- Test ------------------------
    var data = const AccountModel(
      id: 1,
      username: 'user',
      password: 'password',
      isLogin: 0,
    );

    // insert
    // await insertAccount(peet);
    // print(await accounts());

    // update
    data = const AccountModel(
      id: 1,
      username: 'admin',
      password: 'secret',
      isLogin: 0,
    );
    // await updateAccount(peet);
    // print(await accounts());

    // await deleteAccount(1);
    print(await accounts());

    // --------- End Test --------------------
  }
}
