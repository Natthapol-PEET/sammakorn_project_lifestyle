import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';

import '../../../constance.dart';

class DialogDelete extends StatelessWidget {
  final String id;

  const DialogDelete({
    Key key,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    Services services = Services();

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
                        "Delete",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        services.deleteInvite(id);
                        Navigator.pushNamed(context, '/home');

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
