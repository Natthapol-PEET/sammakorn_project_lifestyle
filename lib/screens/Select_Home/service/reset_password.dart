import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import '../../../constance.dart';

Future reset_password_rest(email) async {
  Auth auth = Auth();
  Home home = Home();
  Uri url = Uri.parse("${URL}/resident_reset_password/${email}");
  String resident_id = await auth.getResidentId();
  String home_id = await home.getHomeId();

  var token = await auth.getToken();
  token = token[0]["TOKEN"];

  var response = await http.put(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${token}'
  });

  if (response.statusCode == 201) {
    return true;
  } else {
    String body = utf8.decode(response.bodyBytes);
    Map valueMap = json.decode(body);
    return valueMap['detail'];
  }
}

Future change_password_rest(oldPassword, newPassword) async {
  Auth auth = Auth();
  String resident_id = await auth.getResidentId();
  var token = await auth.getToken();
  token = token[0]["TOKEN"];

  Uri url = Uri.parse("${URL}/resident_change_password/");

  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${token}'
    },
    body: jsonEncode(<String, String>{
      'resident_id': resident_id,
      'old_password': oldPassword,
      'new_password': newPassword,
    }),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    String body = utf8.decode(response.bodyBytes);
    Map valueMap = json.decode(body);
    return valueMap['detail'];
  }
}
