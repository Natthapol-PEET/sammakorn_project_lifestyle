import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../constance.dart';
import 'delete_button.dart';
import 'keepit_button.dart';

class ListNotifiication extends StatelessWidget {
  final String title;
  final String descTime;
  final Color color;
  final Function pass;

  const ListNotifiication({
    Key key,
    @required this.title,
    @required this.descTime,
    @required this.color,
    @required this.pass,
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
              child: color == Colors.blue
                  ? Icon(Icons.manage_accounts)
                  : Icon(Icons.directions_car),
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
                _show_dialod(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _show_dialod(BuildContext context) {
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
            "Are you sure you want to delete\nyour notifications ?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            KeepItButton(),
            DeleteButton(pass: pass),
          ],
        );
      },
    );
  }
}
