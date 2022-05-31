/*
flutter pub run change_app_package_name:main com.lifestyle.vms.entrance
dashboard_status_vms_entrance
dashboard_status_vms_entrance_apk.apk

flutter pub run change_app_package_name:main com.lifestyle.vms.exit
dashboard_status_vms_exit
dashboard_status_vms_exit_apk.apk
*/

// const String HOST = "192.168.1.85";
const String HOST = "vms-service.ngrok.io";
const int PORT = 8080;

String gateBarrierOpenUrl =
    "http://192.168.1.9/user=admin&password=secret&command=OpenGate";
String gateBarrierCloseUrl =
    "http://192.168.1.9/user=admin&password=secret&command=CloseGate";

/* HTTP Config */
Map<String, String> headers = {
  "Authorization": "Bearer nsr0bjfkbmmiarnbkzncvinrabkkvnaddff"
};

// String HTTP_URL = 'http://${HOST}:${PORT}/';
String HTTP_URL = 'http://vms-service.ngrok.io/';

/* HTTP Notification */
// String URL_NOTIFICATION = 'http://${HOST}:${PORT}/notification_pi/';
String URL_NOTIFICATION = '$HTTP_URL/notification_pi/';

String URL_MQTT_FROM_PI = HTTP_URL + 'mqtt-from-pi';

// /* Relay Config pin */
// const int pinIn = 23;
// const int pinOut = 22;

// /* Relay Controller URL */
// const int relayDelay = 10;

/* MQTT config */
// const String mqttBroker = "broker.hivemq.com";
// const int mqttPort = 1883;
// const String mqttUsername = "user1@vms.com";
// const String mqttPassword = "passwd-vms";
// const String mqttClientIdIn = "pi-in-02";
// const String mqttClientIdOut = "pi-out-02";

// List pubTopic = [
//   "pi-to-app/",
//   "pi-to-web",
// ];
