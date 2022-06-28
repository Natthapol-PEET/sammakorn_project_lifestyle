import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var oldPassword = "".obs;
  var newPassword = "".obs;
  var confirmPassword = "".obs;

  @override
  void onInit() {
    oldPassword.value = "";
    newPassword.value = "";
    confirmPassword.value = "";

    super.onInit();
  }
}
