import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constance.dart';

getWhitelistApi(String token, int homeId) async {
  String url = "$domain/v2/whitelist/";

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, int>{"home_id": homeId}),
  );

  List<dynamic> lists = [];

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    lists = json.decode(body);
  }

  return lists;
}
