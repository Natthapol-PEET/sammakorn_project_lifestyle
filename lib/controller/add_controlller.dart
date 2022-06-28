import 'package:get/get.dart';

class AddVisitorController extends GetxController {
  var lock = true.obs;

  var checkFullname = false.obs;
  var checkIdCard = true.obs;

  var fullname = "".obs;
  var idcard = "".obs;
  var license = "".obs;

  onCheck() {
    // print("fullname >> ${fullname.value}");
    // print("idcard >> ${idcard.value}");
    // print("license >> ${license.value}");

    // print(fullname.isNotEmpty && idcard.isNotEmpty);
    // print(fullname.isNotEmpty && idcard.isNotEmpty && license.isNotEmpty);

    List fullnameList = fullname.toString().split(" ");
    fullnameList.removeWhere((item) => item == "");

    // check full name
    if (fullnameList.length == 2)
      checkFullname(true);
    else
      checkFullname(false);

    // check id card
    if (idcard.toString().length == 0 || idcard.toString().length == 13)
      checkIdCard(true);
    else
      checkIdCard(false);

    // print("idcard.toString().length: ${idcard.toString().length}");
    // print("checkIdCard: ${checkIdCard.value}");
    // print('checkFullname >> $checkFullname');

    if (fullnameList.length == 2 && (idcard.toString().length == 0 || idcard.toString().length == 13))
      lock(false);
    else
      lock(true);

    if (fullnameList.length == 2 && (idcard.toString().length == 0 || idcard.toString().length == 13))
      lock(false);
    else
      lock(true);
  }

  clear() {
    fullname.value = "";
    idcard.value = "";
    license.value = "";
    lock(true);
  }
}
