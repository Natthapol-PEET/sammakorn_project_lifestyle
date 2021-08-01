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

  get_resident_stamp() async {
    Uri url = Uri.parse("${URL}/license_plate/get_resident_stamp/");
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

  send_admin_stamp(String log_id, String reason) async {
    Uri url = Uri.parse("${URL}/license_plate/send_admin_stamp/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';

    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{
        "log_id": log_id,
        "reason": reason,
      }),
    );
    return response.statusCode;
  }

  send_admin_delete_blackwhite(String type, String id, String reason) async {
    Uri url = Uri.parse("${URL}/license_plate/send_admin_delete_blackwhite/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';

    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{
        "type": type,
        "id": id,
        "reason": reason,
      }),
    );
    return response.statusCode;
  }

  send_admin_delete(String type, String id, String reason) async {
    Uri url = Uri.parse("${URL}/license_plate/send_admin_delete/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';

    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{
        "type": type,
        "id": id,
        "reason": reason,
      }),
    );
    return response.statusCode;
  }

  get_resident_send_admin() async {
    Uri url = Uri.parse("${URL}/license_plate/get_resident_send_admin/");
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

  resident_cancel_send_admin(String log_id) async {
    Uri url = Uri.parse("${URL}/license_plate/resident_cancel_send_admin/");
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
    Uri url = Uri.parse("${URL}/license_plate/pms_show_list/");
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

  checkout() async {
    Uri url = Uri.parse("${URL}/license_plate/checkout/");
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

  getHome() async {
    Uri url = Uri.parse("${URL}/gethome/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';

    String res_id = await auth.getResidentId();

    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{'resident_id': res_id}));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      List allHome_list = json.decode(body);
      List allHome = [];
      List home_id = [];

      for (var elem in allHome_list) {
        allHome.add(elem['home']);
        home_id.add(elem['home_id']);
      }

      return [allHome, home_id];
    } else {
      return [-1];
    }
  }

  getListItems() async {
    Uri url = Uri.parse("${URL}/listItem_whitelist_blacklist/");

    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String resId = await auth.getResidentId();
    String home_id = await home.getHomeId();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(
          <String, String>{"home_id": home_id, "resident_id": resId}),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      return json.decode(body);
    } else {
      return 301;
    }
  }

  cancel_request_white_black(String type, String id) async {
    Uri url = Uri.parse("${URL}/license_plate/cancel_request_white_black/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{
        "type": type,
        "id": id,
      }),
    );
    return response.statusCode;
  }

  cancel_request_delete_white_black(String type, String id) async {
    Uri url = Uri.parse("${URL}/license_plate/cancel_request_delete_white_black/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';

    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{
        "type": type,
        "id": id,
      }),
    );
    return response.statusCode;
  }
}
