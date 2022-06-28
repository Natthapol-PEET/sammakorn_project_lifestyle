import 'package:dashboard_status_vms_access_control/config/config.dart';
import 'package:http/http.dart' as http;

gateController(String urlControl) async {
  var client = http.Client();
  var url = Uri.parse(urlControl);

  try {
    final response = await client.get(url, headers: headers);
    print("gateController: ${response.statusCode}");
    return response.statusCode;
  } catch (e) {
    print(e);
  }
}
