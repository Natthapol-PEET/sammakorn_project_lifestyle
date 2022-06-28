import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/account_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import 'package:registerapp_flutter/models/account_model.dart';

class WelcomeController extends GetxController {
  final loginController = Get.put(LoginController());
  final accountController = Get.put(AccountController());
  final selectHomeController = Get.put(SelectHomeController());

  var isLogin = false.obs;
  var isLoad = true.obs;

  checkLogin() async {
    List<AccountModel> data = await accountController.account.accounts();

    print("checkLogin");

    if (data[0].isLogin == 1) {
      bool loginStatus = await loginController.callLoginApi(
          data[0].username as String, data[0].password as String);

      print("loginStatus: $loginStatus");

      if (loginStatus) {
        // go to home
        selectHomeController.getHome(false, true);
        return;
      }
    }

    // go to welcome
    isLogin(false);
    isLoad(false);
  }
}
