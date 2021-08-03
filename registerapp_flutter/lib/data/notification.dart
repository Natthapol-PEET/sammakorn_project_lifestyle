import 'package:intl/intl.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'sqlite.dart';

class NotificationDB {
  SQLite sqlite = SQLite('''CREATE TABLE Notification (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          class TEXT,
          home_id INTEGER,
          title TEXT,
          description TEXT, 
          time DATETIME,
          is_read BOOLEAN);''');

  Home home = Home();

  initNotification() async {
    sqlite.queryDatabase('''CREATE TABLE Notification (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          class TEXT,
          home_id INTEGER,
          title TEXT, 
          description TEXT, 
          time DATETIME,
          is_read BOOLEAN);''');
  }

  getNotification() async {
    String homeId = await home.getHomeId();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final String command =
        "SELECT * FROM Notification WHERE time >= '${formattedDate} 00:00:00' AND home_id = ${homeId} ORDER BY time DESC";
    final row = await sqlite.queryDatabase(command);
    // print(row.toList());
    return row.toList();
  }

  getCountNotification() async {
    String homeId = await home.getHomeId();

    final String command =
        "SELECT COUNT(id) AS count FROM Notification WHERE is_read = false AND home_id = ${homeId}";
    final row = await sqlite.queryDatabase(command);
    // print(row.toList());
    return row.toList()[0]['count'].toInt();
  }

  insertNotification(
      String Class, String title, String description, String homeId) async {
    DateTime now = DateTime.now();

    final String command =
        '''INSERT INTO Notification (class, title, description, time, is_read, home_id) 
        VALUES ('${Class}', '${title}', '${description}', '${now}', false, ${homeId})''';
    var row = await sqlite.insertDatabase(command);
    // print("insert Notification: ${row}");
  }

  updateNotification() async {
    final String command =
        "UPDATE Notification SET is_read = true WHERE is_read = false";
    final row = await sqlite.updateDatabase(command);
    // print("UPDATE Notification ${row}");
  }

  deleteNotification(int id) async {
    final String command = "DELETE FROM Notification WHERE id = ${id}";
    final row = await sqlite.deleteDatabase(command);
    // print("id ${id} : ${row}");
  }

  dropNotification() async {
    final String command = "DROP TABLE Notification";
    final row = await sqlite.deleteDatabase(command);
    // print("DROP TABLE Notification ${row}");
  }

  checkDBNotification() async {
    final String command =
        "SELECT name FROM sqlite_master WHERE type IN ('table','view') AND name NOT LIKE 'sqlite_%' ORDER BY 1;";
    final row = await sqlite.queryDatabase(command);
    bool isHave = false;

    for (var elem in row.toList()) {
      // print(elem);

      if (elem['name'] == 'Notification') {
        isHave = true;
      }
    }

    if (!isHave) {
      initNotification();
    }
  }
}
