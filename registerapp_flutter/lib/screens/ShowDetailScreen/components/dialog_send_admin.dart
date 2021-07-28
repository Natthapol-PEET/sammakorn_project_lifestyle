import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';

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
      backgroundColor: Colors.white,
      content: Stack(
        overflow: Overflow.visible,
        children: [
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "ส่งคำขอเพื่อให้นิติสแตมป์",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
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
                    decoration: InputDecoration(
                      labelText: 'เหตุผล *',
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'กรุณากรอกเหตุผล' : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 300, height: 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text("ยืนยัน",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      onPressed: () {
                        

                        if (_formKey.currentState.validate()) {
                          services.send_admin_stamp(id, reasonController.text);
                        Navigator.pushNamed(context, '/home');
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
