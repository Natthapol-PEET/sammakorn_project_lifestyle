import 'package:get/get.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import 'package:registerapp_flutter/screens/Select_Home/service/update_home.dart';
import 'login_controller.dart';

class SelectHomeController extends GetxController {
  final loginController = Get.put(LoginController());

  var homeIds = [].obs;
  var homeId = 0.obs;
  var listItem = [].obs;
  var selectHome = "".obs;
  var isLoading = true.obs;
  var selectIndex = 0.obs;

  setIndex(index) {
    selectIndex.value = index;
    selectHome.value = listItem[index];
    homeId.value = homeIds[index];
    update();
  }

  getHome() async {
    var data = await getHomeApi(loginController.dataLogin.authToken,
        loginController.dataLogin.residentId.toString());

    if (data[0] == -1) return;

    var allHome = data[0];
    var hid = data[1];

    selectHome.value = allHome[0];
    listItem.value = allHome;
    homeIds.value = hid;

    if (listItem.length == 1) {
      goToHomeScreen();
    }

    isLoading(false);
    update();
  }

  goToHomeScreen() async {
    updateHomeRestApi(
        loginController.dataLogin.authToken,
        loginController.dataLogin.residentId.toString(),
        homeId.value.toString());

    Get.offNamed('/home');
  }
}
