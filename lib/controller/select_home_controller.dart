import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/show_dialog.dart';
import 'package:registerapp_flutter/service/socket_service.dart';
import 'package:registerapp_flutter/service/get_home.dart';
import 'package:registerapp_flutter/service/update_home.dart';
import 'login_controller.dart';

class SelectHomeController extends GetxController {
  final loginController = Get.put(LoginController());

  var homeIds = [].obs;
  var homeId = 0.obs;
  var listItem = [].obs;
  var selectHome = "".obs;
  var isLoading = true.obs;
  var selectIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  setIndex(index) {
    selectIndex.value = index;
    selectHome.value = listItem[index];
    homeId.value = homeIds[index];
    update();
  }

  getHome(bool showLoading, bool loginStatus) async {
    if (showLoading) showLoadingDialog();

    var data = await getHomeApi(loginController.dataLogin!.authToken as String,
        loginController.dataLogin!.residentId.toString());

    print("data: $data");

    if (data[0] == -1) return;

    var allHome = data[0];
    var hid = data[1];

    selectHome.value = allHome[0];
    listItem.value = allHome;
    homeIds.value = hid;
    homeId.value = homeIds[0];

    print("isLogin: ${loginController.isLogin.value}");

    if (listItem.length == 1 || loginStatus) {
      goToHomeScreen();
    }

    isLoading(false);
    if (showLoading) EasyLoading.dismiss();
    update();
  }

  goToHomeScreen() async {
    updateHomeRestApi(loginController.dataLogin!.authToken as String,
        loginController.dataLogin!.residentId as int, homeId.value);

    // init socket
    SocketService socketService = SocketService();
    socketService.startSocketClient(homeId.value);

    Get.offNamed('/home');
  }
}
