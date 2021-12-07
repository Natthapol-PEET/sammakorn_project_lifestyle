import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import '../../constance.dart';
import 'components/dropdown_item.dart';

class SelectHomeScreen extends StatelessWidget {
  SelectHomeScreen({Key key}) : super(key: key);

  final controller = Get.put(SelectHomeController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: darkgreen,
        body: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  controller.isLoading.value == false
                      ? DropdownItem(
                          listItem: controller.listItem.value,
                          chosenValue: controller.selectHome.value,
                          onChanged: (value) {
                            controller.selectHome.value = value;
                          },
                        )
                      : Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            height: 150,
                            padding: EdgeInsets.fromLTRB(100, 50, 100, 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black54,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Loading ...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(greenYellow)),
                onPressed: () async {
                  // updateHome
                  int findId = controller.listItem.indexWhere(
                      (item) => item.startsWith(controller.selectHome.value));

                  await controller.home.updateHome(
                    controller.selectHome.value,
                    controller.homeIds[findId].toString(),
                  );

                  // init service
                  homeController.onInit();

                  Get.offNamed('/home');
                },
                child: Text('Go to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    return Future.value(false);
  }
}
