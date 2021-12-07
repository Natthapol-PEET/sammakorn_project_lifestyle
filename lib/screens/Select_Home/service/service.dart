import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/data/auth.dart';
import '../../../constance.dart';

class Services {
  Auth auth = Auth();

  getHome() async {
    Uri url = Uri.parse("${URL}/gethome/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';

    String res_id = await auth.getResidentId();

    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{'resident_id': res_id}));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      List allHome_list = json.decode(body);
      List allHome = [];
      List home_id = [];

      for (var elem in allHome_list) {
        print(elem);

        allHome.add(elem['home']);
        home_id.add(elem['home_id']);
      }

      return [allHome, home_id];
    } else {
      return [-1];
    }
  }
}
