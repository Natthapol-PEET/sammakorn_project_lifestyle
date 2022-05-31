import 'package:flutter/material.dart';

const greenPrimary = Color(0xff003330);
const greenYellow = Color(0xffB2A37A);
const goldenSecondary = Color(0xffCBB989);
const darkgreen = greenPrimary;
const darkgreen200 = Color(0xff214643);
const gray6 = Color(0xff1D1C1C);
const tabBarColor = Color(0xff2D4E4C);
const tabBarBodyColor = greenPrimary;
const listColor = greenPrimary;
const bgDialog = Color(0xFF305250);
const dividerColor = Color(0xffF5F4EC);
const backgrounditem = Color(0xff305250);
const fededWhite = Color(0xff305250);
const fededWhite1 = Color(0xff305300);
const timelineColor = dividerColor;
const inviteColor = Color(0xffB5C21D);
const comingColor = Color(0xffF4AD43);
const infrontColor = Color(0xFF4FB4ED);
const villColor = Color(0xff12976F);
const approveColor = Color(0xff17CD4A);
const disapproveColor = Color(0xffEA464C);
const backtoHomeBtnColor = Color(0xff456B69);
const outColor = Color(0xFFCBB989);

List projectImages = [
  'assets/images/Rectangle 2878.png',
  'assets/images/Rectangle 2870.png',
  'assets/images/Rectangle 2872.png',
  'assets/images/Rectangle 2873.png'
];

// String host = "192.168.43.160";
// String URL = "http://${host}:8080/app_api"; // local
// String WS = "ws://${host}:8080";

// const String serverIp = "192.168.1.85";
// // const String serverIp = "192.168.1.9";
// const String URL = "http://${serverIp}:8080/app_api"; // server aws
// const String mqttBroker = serverIp;

const String serverIp = "vms-service.ngrok.io";
const String domain = "http://$serverIp/app_api"; // ngrok
const String mqttBroker = "broker.hivemq.com";

// const String WS = "ws://${serverIp}:8080";

/* MQTT config */

const int mqttPort = 1883;
const String mqttUsername = "user1@vms.com";
const String mqttPassword = "passwd-vms";
const String mqttClientId = "resident-"; // resident-<device id>

List pubTopic = [
  "app-to-web",
];

List subTopic = [
  "app-to-app/",
  "web-to-app/",
  "pi-to-app/",
];
