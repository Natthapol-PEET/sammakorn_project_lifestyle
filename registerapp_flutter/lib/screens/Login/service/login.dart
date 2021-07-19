import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constance.dart';

class Services {
  login(String username, String password, String home) async {
    Uri url = Uri.parse("${URL}/login_resident/");

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "home": home,
        "username": username,
        "password": password
        // "firstname": firstname,
        // "lastname": lastname,
        // "home_number": address,
        // "license_plate": carplat,
        // "date": select_date,
        // "start_time": start_time,
        // "end_time": end_time
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      return {"statusCode": 401, "token": "Invalid username and/or password"};
    } else {
      return {"statusCode": 500, "token": "server not response"};
    }
  }

  getAllHome() async {
    Uri url = Uri.parse("${URL}/home/");

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      List allHome_list = json.decode(body);
      List allHome = [];
      List home_id = [];

      for (var elem in allHome_list) {
        allHome.add(elem['home']);
        home_id.add(elem['home_id']);
      }

      return [allHome, home_id];
    } else {
      return [-1];
    }
  }
}
