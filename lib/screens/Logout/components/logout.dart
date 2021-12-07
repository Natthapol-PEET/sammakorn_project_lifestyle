import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import '../../../constance.dart';
import '../service/logout.dart';

class LogoutButton extends StatelessWidget {
  LogoutButton({
    Key key,
  }) : super(key: key);

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
      child: GestureDetector(
        onTap: () => _logout(),
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.08,
          decoration: BoxDecoration(
            color: backgrounditem,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text("Logout",
                style: TextStyle(color: goldenSecondary, fontSize: 18)),
          ),
        ),
      ),
    );
  }

  _logout() async {
    Services services = Services();
    await services.logout();
    await controller.closeConnection();
    Get.offAllNamed('/', arguments: "logout");
  }
}
