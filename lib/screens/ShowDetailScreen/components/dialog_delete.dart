import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';

import '../../../constance.dart';

class DialogDelete extends StatelessWidget {
  final String id;

  DialogDelete({
    Key key,
    this.id,
  }) : super(key: key);

  // Getx controller
  final controller = Get.put(HomeController());
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return AlertDialog(
      backgroundColor: bgDialog,
      content: Stack(
        // overflow: Overflow.visible,
        children: [
          // Positioned(
          //   right: -40.0,
          //   top: -40.0,
          //   child: InkResponse(
          //     onTap: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: CircleAvatar(
          //       child: Icon(Icons.close),
          //       backgroundColor: Colors.red,
          //     ),
          //   ),
          // ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Are you sure you want to delete this item ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: TextFormField(),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 300, height: 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: bgDialog,
                        shape: StadiumBorder(),
                        side: BorderSide(
                          width: 0.5,
                          color: goldenSecondary,
                        ),
                      ),
                      child: Text(
                        "Keep it",
                        style: TextStyle(
                          fontSize: 16,
                          color: goldenSecondary,
                        ),
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 300, height: 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: goldenSecondary, shape: StadiumBorder()),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        deleteInviteApi(
                            loginController.dataLogin.authToken, id);
                        Get.toNamed('/home');

                        controller.publishMqtt("app-to-web", "INVITE_VISITOR");
                        controller.publishMqtt("app-to-app", "INVITE_VISITOR");

                        // if (_formKey.currentState.validate()) {
                        //   // _formKey.currentState.save();
                        // }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
