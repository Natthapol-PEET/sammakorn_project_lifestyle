import 'package:flutter_easyloading/flutter_easyloading.dart';

showErrorDialog() => EasyLoading.showError('ระบบขัดข้อง กรุณาลองใหม่อีกครั้ง');

showLoadingDialog() => EasyLoading.show(status: 'กรุณารอสักครู่ ...');
