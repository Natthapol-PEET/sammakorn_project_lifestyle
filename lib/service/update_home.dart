import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/components/show_dialog.dart';
import '../constance.dart';

Future updateHomeRestApi(String token, int residentId, int homeId) async {
  String url = "$domain/v2/update_home/";

  try {
    await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, int>{
        "resident_id": residentId,
        'home_id': homeId,
      }),
    );
  } catch (e) {
    showErrorDialog();
  }
}
