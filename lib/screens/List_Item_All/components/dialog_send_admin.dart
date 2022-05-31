import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';

class DialogSendAdmin extends StatelessWidget {
  final String type;
  final String id;
  final String title;

  const DialogSendAdmin({
    Key key,
    this.id,
    @required this.title,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
                      "คุณต้องการลบหมายเลขทะเบียน \n${title} หรือไม่ ?",
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
                        primary: Colors.redAccent,
                      ),
                      child: Text("ยืนยัน",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // Services services = Services();
                          // services.deleteItem(lists[index]['type'],
                          //     lists[index]['id'].toString());

                          print(reasonController.text);

                          Navigator.pushNamed(context, '/listItem');
                        }
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
