import 'dart:convert';
import 'package:dashboard_status_vms_access_control/config/config.dart';
import 'package:http/http.dart' as http;

class HttpToMqtt {
  var client = http.Client();
  var url = Uri.parse(URL_MQTT_FROM_PI);

  postMqttToServer(String topic, String payload) async {
    try {
      final response = await client.post(
        url,
        headers: headers,
        body: jsonEncode(
          <String, String>{
            "topic": topic,
            "payload": payload,
          },
        ),
      );

      print("postMqttToServer: ${response.statusCode}");

      return response.statusCode;
    } catch (e) {
      print(e);
    }
  }
}
