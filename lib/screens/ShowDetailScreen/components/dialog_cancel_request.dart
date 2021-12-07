import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import '../../../constance.dart';

class DialogCancelRequest extends StatelessWidget {
  final String resident_remove_reason;
  final String type;
  final String id;

  DialogCancelRequest({
    Key key,
    this.resident_remove_reason,
    this.id,
    this.type,
  }) : super(key: key);

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    Services services = Services();

    return AlertDialog(
      backgroundColor: bgDialog,
      content: Stack(
        overflow: Overflow.visible,
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
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Are you sure you want to cancel request ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
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
                      onPressed: () => Navigator.pop(context),
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
                        "Confirm",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        if (resident_remove_reason == '-') {
                          services.cancel_request_white_black(type, id);
                        } else {
                          services.cancel_request_delete_white_black(type, id);
                        }

                        // var socket = SocketManager();
                        // socket.send_message(
                        //     'RESIDENT_REQUEST_WHITELIST', 'web');
                        // socket.send_message(
                        //     'RESIDENT_REQUEST_BLACKLIST', 'web');

                        // socket.send_message(
                        //     'RESIDENT_REQUEST_WHITEBLACK', 'app');

                        controller.publishMqtt("app-to-web", "RESIDENT_REQUEST_WHITELIST");
                        controller.publishMqtt("app-to-web", "RESIDENT_REQUEST_BLACKLIST");
                        controller.publishMqtt("app-to-app", "RESIDENT_REQUEST_WHITEBLACK");

                        Navigator.pushNamed(context, '/home');

                        // if (_formKey.currentState.validate()) {
                        //   // _formKey.currentState.save();
                        // }
                      },
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: TextFormField(),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
