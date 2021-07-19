import 'sqlite.dart';

class Home {
  SQLite sqlite = SQLite("CREATE TABLE HomeData (home TEXT, home_id INTEGER);");

  initHome() async {
    sqlite.queryDatabase("CREATE TABLE HomeData (home TEXT, home_id INTEGER);");

    insertHome();
  }

  insertHome() async {
    final String command =
        "INSERT INTO HomeData (home, home_id) values ('home', 0)";
    var row = await sqlite.insertDatabase(command);
    print("insertHome: ${row}");
  }

  checkDBHome() async {
    // final String command =
    //     "SELECT name FROM sqlite_master WHERE type IN ('table','view') AND name NOT LIKE 'sqlite_%' ORDER BY 1;";
    // final row = await sqlite.queryDatabase(command);

    // for (var elem in row.toList()) {
    //   print(elem);

    //   if (elem['name'] == 'HomeData') {
    //     return true;
    //   }
    // }
    // return false;

    try {
      var row = await getHomeAndId();
      if (row.isEmpty || row == null) {
        insertHome();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      initHome();
      return true;
    }
  }

  getHome() async {
    final String command = "SELECT home FROM HomeData";
    final row = await sqlite.queryDatabase(command);

    return row.toList()[0]['home'].toString();
    // row.forEach((value) {
    //   return value["TOKEN"];
    // });
  }

  getHomeId() async {
    final String command = "SELECT home_id FROM HomeData";
    final row = await sqlite.queryDatabase(command);

    return row.toList()[0]['home_id'].toString();
  }

  getHomeAndId() async {
    final String command = "SELECT * FROM HomeData";
    final row = await sqlite.queryDatabase(command);

    return row;
  }

  void updateHome(String home, String home_id) async {
    final String command =
        "UPDATE HomeData SET home = '${home}', home_id = ${home_id};";
    final row = await sqlite.updateDatabase(command);
    print(row);
  }

  void deleteHome() async {
    final String command = "DROP TABLE HomeData";
    final row = await sqlite.deleteDatabase(command);
    print(row);
  }
}
