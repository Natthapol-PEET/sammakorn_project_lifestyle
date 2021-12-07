import 'package:get/get.dart';
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/data/notification.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/service/clear_account.dart';
import 'package:registerapp_flutter/service/device_id.dart';

class InitDatabaseController extends GetxController {
  var isLogin = false.obs;
  var isLoad = true.obs;

  Auth auth = Auth();
  Home home = Home();
  NotificationDB notification = NotificationDB();
  Device device = Device();

  @override
  void onInit() {
    // checkDB("init");
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    // home.deleteHome();
    // auth.deleteToken();
    // notification.deleteNotification();

    super.onInit();
  }

  Future checkDB(String data) async {
    bool isHaveDBH = await home.checkDBHome();
    bool isHaveDBA = await auth.checkDBAuth();
    bool isHaveDBN = await notification.checkDBNotification();

    print("Start search table in DB");
    print(isHaveDBH);
    print(isHaveDBA);
    print(isHaveDBN);
    print("Stop search table in DB");

    if (data == "logout") {
      Future.delayed(Duration(seconds: 1), () => checkLogin());
    } else {
      checkLogin();
    }
  }

  checkLogin() async {
    // check login in database on server
    String deviceId = await device.getId();

    // check login in database on local
    var token = await auth.getToken();

    if (token[0]["TOKEN"] == "-1") {
      // ckeck login
      // is login => logout
      await clearAccount(deviceId);

      isLogin(false);
      isLoad(false);
    } else {
      isLogin(true);
      isLoad(false);
    }
  }
}
