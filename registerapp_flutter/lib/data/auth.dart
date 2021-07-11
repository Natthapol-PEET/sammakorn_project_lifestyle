import 'sqlite.dart';

class Auth {
  SQLite sqlite = SQLite("CREATE TABLE Auth (TOKEN TEXT);");

  void initAuth() {
    sqlite.queryDatabase("CREATE TABLE Auth (TOKEN TEXT);");

    insertToken();
  }

  void insertToken() async {
    final String command = "INSERT INTO Auth (TOKEN) values ('token')";
    var row = await sqlite.insertDatabase(command);
    print(row);
  }

  checkDBAuth() async {
    final String command = "SELECT name FROM sqlite_master WHERE type IN ('table','view') AND name NOT LIKE 'sqlite_%' ORDER BY 1;";
    final row = await sqlite.queryDatabase(command);
    
    for(var elem in row.toList()) {
      if(elem['name'] == 'Auth') {
        return true;
      }
    }

    return false;
  }

  getToken() async {
    final String command = "SELECT TOKEN FROM Auth";
    final row = await sqlite.queryDatabase(command);
    return row;
    // row.forEach((value) {
    //   return value["TOKEN"];
    // });
  }

  void updateToken(String token) async {
    final String command = "UPDATE Auth SET TOKEN = '${token}'";
    final row = await sqlite.updateDatabase(command);
    print(row);
  }

  void deleteToken() async {
    final String command = "DELETE FROM Auth";
    final row = await sqlite.deleteDatabase(command);
    print(row);
  }
}
