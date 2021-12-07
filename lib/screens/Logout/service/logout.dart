import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/data/auth.dart';
import '../../../constance.dart';

class Services {
  Auth auth = Auth();

  Future logout() async {
    Uri url = Uri.parse("${URL}/logout/");
    String resident_id = await auth.getResidentId();

    var token = await auth.getToken();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer  ${token[0]["TOKEN"]}'
      },
      body: jsonEncode(<String, String>{"resident_id": resident_id}),
    );

    if (response.statusCode == 200) {
      print("logout successful");
      auth.updateToken("-1", "0", "NULL");

      return 200;
    }
  }
}
