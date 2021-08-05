import 'package:flutter/material.dart';
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import 'package:registerapp_flutter/service/socket.dart';
import 'package:web_socket_channel/io.dart';
import '../../../constance.dart';

class DialogSendAdmin extends StatelessWidget {
  final String id;

  const DialogSendAdmin({
    Key key,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    Services services = Services();
    final reasonController = TextEditingController();

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
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Send request to juristic",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: reasonController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Reason *',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'กรุณากรอกเหตุผล' : null,
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
                        "Send",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          var socket = SocketManager();
                          socket.send_message('RESIDENT_REQUEST_STAMP', 'web');
                          socket.send_message('RESIDENT_SEND_STAMP', 'app');

                          services.send_admin_stamp(id, reasonController.text);
                          Navigator.pushNamed(context, '/home');
                        }
                      },
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
                        primary: bgDialog,
                        shape: StadiumBorder(),
                        side: BorderSide(
                          width: 0.5,
                          color: goldenSecondary,
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          color: goldenSecondary,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
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
