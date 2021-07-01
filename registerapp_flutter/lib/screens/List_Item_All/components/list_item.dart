import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../constance.dart';
import 'cancel_button.dart';
import 'delete_button.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String descTime;
  final Color color;

  const ListItem({
    Key key,
    @required this.title,
    @required this.descTime,
    @required this.color,
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
                _show_dialod(context, color);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _show_dialod(BuildContext context, Color color) {
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
            color == Colors.red
                ? "Are you sure you want to delete\nyour Blacklist ?"
                : "Are you sure you want to delete\nyour Whitelist ?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            CancelButton(),
            DeleteButton(),
          ],
        );
      },
    );
  }
}
