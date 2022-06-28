import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/components/show_dialog.dart';
import '../../../constance.dart';

getHomeApi(String token, String residentId) async {
  String url = "$domain/v2/gethome/";

  try {
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{'resident_id': residentId}));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      List allHomeList = json.decode(body);
      List allHome = [];
      List homeId = [];

      for (var elem in allHomeList) {
        allHome.add(elem['home']);
        homeId.add(elem['home_id']);
      }

      return [allHome, homeId];
    } else {
      return [-1];
    }
  } catch (e) {
    showErrorDialog();
  }
}