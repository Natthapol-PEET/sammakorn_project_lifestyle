import 'sqlite.dart';

class Home {
  SQLite sqlite = SQLite("CREATE TABLE Home (home TEXT);");

  void initHome() async {
    sqlite.queryDatabase("CREATE TABLE Home (home TEXT);");

    insertHome();
  }

  checkDBHome() async {
    final String command = "SELECT name FROM sqlite_master WHERE type IN ('table','view') AND name NOT LIKE 'sqlite_%' ORDER BY 1;";
    final row = await sqlite.queryDatabase(command);
    
    for(var elem in row.toList()) {
      if(elem['name'] == 'Home') {
        return true;
      }
    }

    return false;
  }

  void insertHome() async {
    final String command = "INSERT INTO Home (home) values ('home')";
    var row = await sqlite.insertDatabase(command);
    print(row);
  }

  getHome() async {
    final String command = "SELECT home FROM Home";
    final row = await sqlite.queryDatabase(command);
    return row.toList()[0]['home'].toString();
    // row.forEach((value) {
    //   return value["TOKEN"];
    // });
  }

  void updateHome(String home) async {
    final String command = "UPDATE Home SET home = '${home}'";
    final row = await sqlite.updateDatabase(command);
    print(row);
  }

  void deleteHome() async {
    final String command = "DELETE FROM Home";
    final row = await sqlite.deleteDatabase(command);
    print(row);
  }
}
