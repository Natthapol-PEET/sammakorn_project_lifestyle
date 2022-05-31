import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var oldPassword = "".obs;
  var newPassword = "".obs;
  var confirmPassword = "".obs;

  var checkOldPassword = false.obs;
  var checkPassword = false.obs;

  var lock = true.obs;

  void onCheck() {
    print("oldPassword >> ${oldPassword.value}");
    print("newPassword >> ${newPassword.value}");
    print("confirmPassword >> ${confirmPassword.value}");

    // check old password
    if (oldPassword.value != "") {
      checkOldPassword(true);
    } else {
      checkOldPassword(false);
    }

    // check password
    if (oldPassword.value != "" || newPassword.value == confirmPassword.value) {
      checkPassword(true);
      lock(false);
    } else {
      checkPassword(false);
      lock(true);
    }
  }
}
