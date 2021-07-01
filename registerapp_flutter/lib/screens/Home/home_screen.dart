import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/add_licente_plate_screen.dart';
import 'package:registerapp_flutter/screens/List_Item_All/list_item_screen.dart';
import '../../constance.dart';
import 'components/app_bar_action.dart';
import 'components/app_bar_title.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkgreen200,
        appBar: AppBar(
          title: AppBarTitle(),
          backgroundColor: darkgreen,
          automaticallyImplyLeading: false,
          actions: [
            AppBarAction(),
          ],
        ),
        body: Body(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddLicensePlateScreen()),
                  );
                },
                child: Icon(Icons.add, size: 36, color: tabBarBodyColor),
                backgroundColor: goldenSecondary,
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListItemScreen()),
                  );
                },
                child: Icon(Icons.view_list, size: 36, color: tabBarBodyColor),
                backgroundColor: goldenSecondary,
              )
            ],
          ),
        ));
  }
}
