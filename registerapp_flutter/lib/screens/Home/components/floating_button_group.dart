import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/add_licente_plate_screen.dart';
import 'package:registerapp_flutter/screens/List_Item_All/list_item_screen.dart';
import '../../../constance.dart';

class FloatingButtonGroup extends StatelessWidget {
  const FloatingButtonGroup({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              Navigator.pushNamed(context, '/addLicenseplate');
            },
            child: Icon(Icons.add, size: 36, color: tabBarBodyColor),
            backgroundColor: goldenSecondary,
          ),
          SizedBox(height: 10),
          // FloatingActionButton(
          //   heroTag: "btn2",
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/listItem');
          //   },
          //   child: Icon(Icons.view_list, size: 36, color: tabBarBodyColor),
          //   backgroundColor: goldenSecondary,
          // ),
        ],
      ),
    );
  }
}
