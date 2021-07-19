import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import '../../../constance.dart';

class Services {
  Auth auth = Auth();
  Home home = Home();

  getHistory() async {
    Uri url = Uri.parse("${URL}/history/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String home_id = await home.getHomeId();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{"home_id": home_id}),
    );

    List object = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var lists = json.decode(body);
      object = lists.toList();
      // for (var elem in lists) {
      //   object.add(elem);
      // }
    }
    return object;
  }

  getLicenseInvite() async {
    Uri url = Uri.parse("${URL}/license_plate/invite/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String home_id = await home.getHomeId();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{"home_id": home_id}),
    );

    List object = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var lists = json.decode(body);
      object = lists.toList();
    }
    return object;
  }

  deleteInvite(String visitor_id) async {
    Uri url = Uri.parse("${URL}/license_plate/invite/delete/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{"visitor_id": visitor_id}),
    );
    return response.statusCode;
  }

  coming_and_walk() async {
    Uri url = Uri.parse("${URL}/license_plate/coming_and_walk/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String home_id = await home.getHomeId();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{"home_id": home_id}),
    );

    List object = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var lists = json.decode(body);
      object = lists.toList();
    }
    return object;
  }

  resident_stamp(String log_id) async {
    Uri url = Uri.parse("${URL}/license_plate/resident_stamp/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';

    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{"log_id": log_id}),
    );
    return response.statusCode;
  }

  hsa_stamp() async {
    Uri url = Uri.parse("${URL}/license_plate/hsa_stamp/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String home_id = await home.getHomeId();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{"home_id": home_id}),
    );

    List object = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var lists = json.decode(body);
      object = lists.toList();
    }
    return object;
  }

  send_admin_stamp(String log_id) async {
    Uri url = Uri.parse("${URL}/license_plate/send_admin_stamp/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';

    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{"log_id": log_id}),
    );
    return response.statusCode;
  }

  pms_show() async {

  }
}
