import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';

import '../../../constance.dart';

class DialogShow extends StatelessWidget {
  final String key1;
  final String key2;
  final String value1;
  final String value2;

  const DialogShow({
    Key key,
    this.key1,
    this.key2,
    this.value1,
    this.value2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    Services services = Services();
    final reasonController = TextEditingController();

    return AlertDialog(
      backgroundColor: bgDialog,
      content: Stack(
        overflow: Overflow.visible,
        children: [
          Positioned(
            // right: -40.0,
            // top: -40.0,
            top: -20,
            right: -20,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close, color: Color(0xffF5F4EC), size: 30),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.question_answer_outlined,
                    size: 80, color: goldenSecondary),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 18,
                        color: goldenSecondary,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 8,
                        child: Center(
                          child: Text(
                            value1,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      // Flexible(child: Text(value1)),
                    ],
                  ),
                ),
                // key2 == ''
                //     ? Container()
                //     : Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Row(
                //           children: [
                //             Text("${key2}: "),
                //             Flexible(child: Text(value2)),
                //           ],
                //         ),
                //       ),
                // Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: reasonController,
                //     keyboardType: TextInputType.multiline,
                //     maxLines: 3,
                //     decoration: InputDecoration(
                //       labelText: 'เหตุผล *',
                //     ),
                //     validator: (value) =>
                //         value.isEmpty ? 'กรุณากรอกเหตุผล' : null,
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 30),
                //   child: ConstrainedBox(
                //     constraints:
                //         BoxConstraints.tightFor(width: 300, height: 40),
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         primary: Colors.green,
                //       ),
                //       child: Text("ยืนยัน",
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold, fontSize: 18)),
                //       onPressed: () {
                //         // if (_formKey.currentState.validate()) {
                //         //   services.send_admin_stamp(id, reasonController.text);
                //         //   Navigator.pushNamed(context, '/home');
                //         // }
                //       },
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
