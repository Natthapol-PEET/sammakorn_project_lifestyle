/*
flutter pub run change_app_package_name:main com.lifestyle.vms.entrance
dashboard_status_vms_entrance
dashboard_status_vms_entrance_apk.apk

flutter pub run change_app_package_name:main com.lifestyle.vms.exit
dashboard_status_vms_exit
dashboard_status_vms_exit_apk.apk
*/

/* Service Config */
const String HOST = "vms-service.ngrok.io";
String server = 'http://$HOST/';

Map<String, String> headers = {
  "Authorization": "Bearer nsr0bjfkbmmiarnbkzncvinrabkkvnaddff"
};

/* Gate Barier Config */
// String gateBarrierOpenUrl =
//     "http://192.168.1.9/user=admin&password=secret&command=OpenGate";
// String gateBarrierCloseUrl =
//     "http://192.168.1.9/user=admin&password=secret&command=CloseGate";
String gateBarrierOpenUrl = server + 'gate/open/';
String gateBarrierCloseUrl = server + 'gate/close/';
