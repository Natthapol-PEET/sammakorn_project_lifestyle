import 'package:get/get.dart';

class AddLicenseController extends GetxController {
  var lock = true.obs;
  var classValue = "คน".obs;

  var fullname = "".obs;
  var idcard = "".obs;
  var license = "".obs;

  onCheck() {
    print("classValue >> ${classValue}");
    print("fullname >> ${fullname.value}");
    print("idcard >> ${idcard.value}");
    print("license >> ${license.value}");

    print(fullname.isNotEmpty && idcard.isNotEmpty);
    print(fullname.isNotEmpty && idcard.isNotEmpty && license.isNotEmpty);

    List list = fullname.toString().split(" ");
    list.removeWhere((item) => item == "");

    if (classValue.value == 'คน') {
      if (list.length == 2 && idcard.toString().length == 13) {
        lock(false);
      } else {
        lock(true);
      }
    } else {
      if (list.length == 2 &&
          idcard.toString().length == 13 &&
          license.isNotEmpty) {
        lock(false);
      } else {
        lock(true);
      }
    }
  }

  clear() {
    classValue.value = "คน";
    fullname.value = "";
    idcard.value = "";
    license.value = "";
    lock(true);
  }
}
