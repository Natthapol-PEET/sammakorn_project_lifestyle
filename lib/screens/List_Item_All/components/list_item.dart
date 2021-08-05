import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:registerapp_flutter/screens/List_Item_All/service/service.dart';
import '../../../constance.dart';
import 'cancel_button.dart';
import 'delete_button.dart';
import 'dialog_send_admin.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String descTime;
  final Color color;
  final Function pass;
  final String type;
  final String id;

  const ListItem({
    Key key,
    @required this.title,
    @required this.descTime,
    @required this.color,
    @required this.pass,
    this.id,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          color: listColor,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
              child: Icon(Icons.directions_car),
              foregroundColor: Colors.white,
            ),
            title: Text(title, style: TextStyle(color: Colors.white)),
            subtitle:
                Text(descTime, style: TextStyle(color: Colors.grey.shade400)),
          ),
        ),
        secondaryActions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconSlideAction(
              color: goldenSecondary,
              iconWidget:
                  Icon(Icons.delete_outline, size: 36, color: Colors.white),
              onTap: () {
                // _show_dialog(context, color);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogSendAdmin(
                      title: title,
                      type: type,
                      id: id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _show_dialog(BuildContext context, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgDialog,
          title: new Text(
            "Alert!!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "คุณต้องการลบหมายเลขทะเบียน \n${title} หรือไม่ ?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            CancelButton(),
            DeleteButton(
              pass: pass,
            ),
          ],
        );
      },
    );
  }
}
