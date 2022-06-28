import 'package:path/path.dart';
import 'package:registerapp_flutter/models/notification_model.dart';
import 'package:sqflite/sqflite.dart';

class Notification {
  Database? db;

  Future getDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'notification_database.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            class TEXT,
            home_id INTEGER,
            title TEXT,
            description TEXT, 
            datetime TEXT,
            is_read INTEGER
          );
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertNotification(NotificationModel notification) async {
    await db!.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NotificationModel>> notifications(int homeId) async {
    final List<Map<String, dynamic>> maps = await db!.query(
      'notifications',
      where: "home_id = $homeId",
    );

    return List.generate(maps.length, (i) {
      return NotificationModel(
        id: maps[i]['id'],
        classs: maps[i]['class'],
        homeId: maps[i]['home_id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        datetime: maps[i]['datetime'],
        isRead: maps[i]['is_read'] == 1 ? true : false,
      );
    });
  }

  Future<void> updateNotification(int homeId) async {
    String sql = "UPDATE notifications SET is_read = 1 WHERE home_id = $homeId";
    db!.execute(sql);
    // await db!.update(
    //   'notifications',
    //   notification.toMap(),
    //   where: 'id = ?',
    //   whereArgs: [notification.id],
    // );
  }

  Future<void> deleteOneNotification(int id) async {
    await db!.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllNotification(int homeId) async {
    await db!.delete(
      'notifications',
      where: 'home_id = ?',
      whereArgs: [homeId],
    );
  }

  void dropTable() async {
    String sql = "DROP TABLE notifications";
    await db!.execute(sql);
  }

  Future close() async => db!.close();
}
