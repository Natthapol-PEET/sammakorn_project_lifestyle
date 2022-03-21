import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import '../../../constance.dart';

Future update_home_rest() async {
  Auth auth = Auth();
  Home home = Home();
  Uri url = Uri.parse("${URL}/update_home/");
  String resident_id = await auth.getResidentId();
  String home_id = await home.getHomeId();

  var token = await auth.getToken();
  token = token[0]["TOKEN"];

  var response = await http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${token}'
      // 'Authorization': token
    },
    body: jsonEncode(<String, int>{
      "resident_id": int.parse(resident_id),
      'home_id': int.parse(home_id),
    }),
  );
}
