import 'sqlite.dart';

class Auth {
  SQLite sqlite = SQLite(
      "CREATE TABLE Auth (TOKEN TEXT, ID_RES INTEGER, Username TEXT, device_token TEXT);");

  initAuth() async {
    sqlite.queryDatabase(
        "CREATE TABLE Auth (TOKEN TEXT, ID_RES INTEGER, Username TEXT, device_token TEXT);");

    insertToken();
  }

  insertToken() async {
    final String command =
        "INSERT INTO Auth (TOKEN, ID_RES, Username, device_token) values ('-1', 0, 'NULL', 'device_token')";
    var row = await sqlite.insertDatabase(command);
    print("insertToken: ${row}");
  }

  checkDBAuth() async {
    // final String command =
    //     "SELECT name FROM sqlite_master WHERE type IN ('table','view') AND name NOT LIKE 'sqlite_%' ORDER BY 1;";
    // final row = await sqlite.queryDatabase(command);

    // for (var elem in row.toList()) {
    //   if (elem['name'] == 'Auth') {
    //     return true;
    //   }
    // }
    // return false;

    try {
      var row = await getToken();
      if (row.isEmpty || row == null) {
        insertToken();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      initAuth();
      return true;
    }
  }

  getToken() async {
    final String command = "SELECT TOKEN, ID_RES FROM Auth";
    final row = await sqlite.queryDatabase(command);
    return row;
    // row.forEach((value) {
    //   return value["TOKEN"];
    // });
  }

  getResidentId() async {
    final String command = "SELECT ID_RES FROM Auth";
    final row = await sqlite.queryDatabase(command);
    return row.toList()[0]['ID_RES'].toString();
  }

  void updateDeviceToken(String token) async {
    final String command = "UPDATE Auth SET device_token = '${token}';";
    final row = await sqlite.updateDatabase(command);
    print("UPDATE Auth ${row}");
  }

  getDeviceToken() async {
    final String command = "SELECT device_token FROM Auth";
    final row = await sqlite.queryDatabase(command);
    return row.toList()[0]['device_token'].toString();
  }

  getUser() async {
    final String command = "SELECT Username FROM Auth";
    final row = await sqlite.queryDatabase(command);
    return row[0]["Username"];
  }

  void updateToken(String token, String id, String Username) async {
    final String command =
        "UPDATE Auth SET TOKEN = '${token}', ID_RES = ${id}, Username = '${Username}';";
    final row = await sqlite.updateDatabase(command);
    print("UPDATE Auth ${row}");
  }

  void deleteToken() async {
    final String command = "DROP TABLE Auth";
    final row = await sqlite.deleteDatabase(command);
    print("DROP TABLE Auth ${row}");
  }
}
