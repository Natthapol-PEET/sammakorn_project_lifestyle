import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var oldPassword = "".obs;
  var newPassword = "".obs;
  var confirmPassword = "".obs;

  var lock = true.obs;

  void onCheck() {
    print("oldPassword >> ${oldPassword.value}");
    print("newPassword >> ${newPassword.value}");
    print("confirmPassword >> ${confirmPassword.value}");

    if (newPassword.value == confirmPassword.value) {
      lock(false);
    } else {
      lock(true);
    }
  }
}
