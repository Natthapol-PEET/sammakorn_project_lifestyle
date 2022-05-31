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

  getNotification(int homeId) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final String command =
        "SELECT * FROM Notification WHERE time >= '$formattedDate 00:00:00' AND home_id = $homeId ORDER BY time DESC";
    final row = await sqlite.queryDatabase(command);
    // print(row.toList());
    return row.toList();
  }

  getCountNotification(int homeId) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final String command = """
                SELECT COUNT(id) AS count 
                  FROM Notification 
                  WHERE is_read = 0
                    AND home_id = $homeId
                    AND time >= '$formattedDate 00:00:00'
            """;

    final row = await sqlite.queryDatabase(command);

    // select();
    return row.toList()[0]['count'].toString();
  }

  select() async {
    String command = "SELECT * FROM Notification";
    final row = await sqlite.queryDatabase(command);

    for (var d in row) {
      print('row >> ${d}');
    }
  }

  insertNotification(
      String Class, String title, String description, String homeId) async {
    DateTime now = DateTime.now();

    String command = """
          INSERT INTO Notification (class, title, description, time, is_read, home_id) 
            VALUES ('${Class}', '${title}', '${description}', '${now}', 0, ${homeId})
        """;

    print('command >> ${command}');

    await sqlite.insertDatabase(command);

    // command = """SELECT * FROM Notification""";
    // final row = await sqlite.queryDatabase(command);
    // print("row >> ${row}");
  }

  updateNotification() async {
    final String command = """
        UPDATE Notification 
          SET is_read = 1 
            WHERE is_read = 0
      """;

    await sqlite.updateDatabase(command);
  }

  deleteNotification(int id) async {
    final String command = """
        DELETE FROM Notification 
          WHERE id = ${id}
      """;
    sqlite.deleteDatabase(command);
  }

  deleteAllNotification(String homeId) async {
    final String command = """
        DELETE FROM Notification 
          WHERE home_id = ${homeId}
      """;
    sqlite.deleteDatabase(command);
  }

  dropNotification() async {
    final String command = "DROP TABLE Notification";
    await sqlite.deleteDatabase(command);
  }

  checkDBNotification() async {
    String command = """
        SELECT name 
          FROM sqlite_master 
            WHERE type IN ('table','view') 
              AND name NOT LIKE 'sqlite_%' 
              ORDER BY 1;
      """;

    var row = await sqlite.queryDatabase(command);
    bool isHave = false;

    for (var elem in row.toList()) {
      print("elem >> ${elem}");
      if (elem['name'] == 'Notification') {
        isHave = true;
      }
    }

    if (isHave == false) {
      initNotification();
    }

    return true;
  }
}
