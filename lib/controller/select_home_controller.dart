import 'package:get/get.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Select_Home/service/service.dart';

class SelectHomeController extends GetxController {
  Services services = Services();
  Home home = Home();

  var homeIds = [].obs;
  var listItem = [].obs;
  var selectHome = "".obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    getHome();

    super.onInit();
  }

  getHome() async {
    var data = await services.getHome();
    var allHome = data[0];
    var homeId = data[1];

    print(data);

    if (allHome != -1) {
      selectHome.value = allHome[0];
      listItem.value = allHome;
      homeIds.value = homeId;

      isLoading(false);
    }
  }
}
