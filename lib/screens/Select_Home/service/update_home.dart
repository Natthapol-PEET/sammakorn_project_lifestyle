import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constance.dart';

Future updateHomeRestApi(String token, String residentId, String homeId) async {
  String url = "$domain/update_home/";

  var response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, int>{
      "resident_id": int.parse(residentId),
      'home_id': int.parse(homeId),
    }),
  );
}
