import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/account_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import 'package:registerapp_flutter/models/account_model.dart';
import 'package:registerapp_flutter/service/device_id.dart';

class WelcomeController extends GetxController {
  final loginController = Get.put(LoginController());
  final accountController = Get.put(AccountController());
  final selectHomeController = Get.put(SelectHomeController());

  var isLogin = false.obs;
  var isLoad = true.obs;

  Device device = Device();

  checkLogin() async {
    List<AccountModel> data = await accountController.account.accounts();

    if (data[0].isLogin == 1) {
      bool loginStatus = await loginController.callLoginApi(
          data[0].username, data[0].password);

      if (loginStatus) {
        // go to home

        selectHomeController.getHome();

        return;
      }
    }

    // go to welcome
    isLogin(false);
    isLoad(false);
  }
}
