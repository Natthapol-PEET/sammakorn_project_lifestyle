import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/data/auth.dart';
import '../../../constance.dart';

class Services {
  logout() async {
    Uri url = Uri.parse("${URL}/logout/");
    Auth auth = Auth();

    var token = await auth.getToken();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer  ${token[0]["TOKEN"]}'
      },
      body: jsonEncode(<String, String>{
        // "username": username,
        // "password": password
        // "firstname": firstname,
        // "lastname": lastname,
        // "home_number": address,
        // "license_plate": carplat,
        // "date": select_date,
        // "start_time": start_time,
        // "end_time": end_time
      }),
    );

    if (response.statusCode == 302) {
      print("logout successful");
      auth.updateToken("-1");
    }
  }
}
