import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import 'package:registerapp_flutter/data/notification.dart';
import 'package:registerapp_flutter/models/notification_list_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationController extends GetxController {
  final selectHomeController = Get.put(SelectHomeController());
  Notification notification = Notification();

  var lists = <NotificationListModel>[].obs;
  var countAlert = 0.obs;

  @override
  void onInit() {
    notification.getDatabase();

    // set location time ago
    timeago.setLocaleMessages('th', timeago.ThMessages());
    // final fifteenAgo = DateTime.now().subtract(Duration(minutes: 15));
    // print(timeago.format(fifteenAgo, locale: 'th'));

    super.onInit();
  }

  getNotification() async {
    lists.clear();
    // require homeId
    var noti =
        await notification.notifications(selectHomeController.homeId.value);

    noti.forEach((item) {
      lists.add(
        NotificationListModel(
          id: item.id ?? 0,
          classs: item.classs ?? '-',
          description: item.description ?? '-',
          timeAgo: timeago.format(DateTime.parse(item.datetime as String),
              locale: 'th'),
        ),
      );

      if (item.isRead == false) countAlert += 1;
    });

    lists.value = List.from(lists.reversed);
  }

  deleteAll() async {
    // require homeId
    await notification.deleteAllNotification(selectHomeController.homeId.value);
  }

  updateNotification() async {
    // require homeId
    // set is_read = true
    await notification.updateNotification(selectHomeController.homeId.value);
  }

  delete(int id) async {
    await notification.deleteOneNotification(id);
  }
}
