import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constance.dart';

getListItemsApi(String token, String homeId, String residentId) async {
  String url = "$domain/listItem_whitelist_blacklist/";

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(
        <String, String>{"home_id": homeId, "resident_id": residentId}),
  );

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    return json.decode(body);
  } else {
    return 301;
  }
}

deleteItem(String token, String type, String index) async {
  String url = "$domain/delete_backlist_whitelist/";

  var response = await http.delete(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{"type": type, "index": index}),
  );

  return response.body;
}
