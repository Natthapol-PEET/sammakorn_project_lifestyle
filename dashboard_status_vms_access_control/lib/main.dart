// @dart = 2.9
import 'package:dashboard_status_vms_access_control/views/Entrance/no_pass.dart';
import 'package:dashboard_status_vms_access_control/views/Entrance/pass.dart';
import 'package:dashboard_status_vms_access_control/views/Entrance/welcome.dart';
import 'package:dashboard_status_vms_access_control/views/Error/network_error.dart';
import 'package:dashboard_status_vms_access_control/views/Exit/leave.dart';
import 'package:dashboard_status_vms_access_control/views/Exit/leave_the_artani.dart';
import 'package:dashboard_status_vms_access_control/views/Exit/loading.dart';
import 'package:dashboard_status_vms_access_control/views/Exit/no_pass_exit.dart';
import 'package:dashboard_status_vms_access_control/views/Exit/nopass_desc.dart';
import 'package:dashboard_status_vms_access_control/views/Exit/pass_card_screen.dart';
import 'package:dashboard_status_vms_access_control/views/Exit/thanks.dart';
import 'package:dashboard_status_vms_access_control/views/InitScreen/init_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  runApp(MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  // เปิดใช้งาน พักหน้าจอ
  Wakelock.enable();

  // Hide status bar and bottom navigation bar
  SystemChrome.setEnabledSystemUIOverlays([]);
  // Lock Screen Orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VMS Monitoring System',
      debugShowCheckedModeBanner: false,
      initialRoute: '/init',
      getPages: [
        // init loading
        GetPage(name: '/init', page: () => InitScreen()),
        // Loadding
        GetPage(name: '/loading', page: () => LoadingScreen()),
        // Error Network
        GetPage(name: '/no_network', page: () => NoNetworkScreen()),

        // entrance to project
        GetPage(name: '/', page: () => WelcomeScreen()),
        GetPage(name: '/pass', page: () => PassScreen()),
        GetPage(name: '/nopass', page: () => NoPassScreen()),
        // exit to project
        GetPage(name: '/leave_the_artani', page: () => LeaveTheArtaniScreen()),
        GetPage(name: '/pass_card', page: () => PassCardScreen()),
        GetPage(name: '/nopass_exit', page: () => NoPassExitScreen()),
        GetPage(name: '/nopass_desc', page: () => NoPassDesc()),
        GetPage(name: '/leave', page: () => LeaveScreen()),
        GetPage(name: '/thanks', page: () => ThanksScreen()),
      ],
    );
  }
}
