import 'package:flutter/material.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/add_licente_plate_screen.dart';
import 'package:registerapp_flutter/screens/List_Item_All/list_item_screen.dart';
import '../../constance.dart';
import 'components/app_bar_action.dart';
import 'components/app_bar_title.dart';
import 'components/list_project.dart';
import 'components/list_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "";

  @override
  void initState() {
    super.initState();

    getHome();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: darkgreen200,
          appBar: AppBar(
            title: AppBarTitle(title: title),
            backgroundColor: darkgreen,
            automaticallyImplyLeading: false,
            actions: [
              AppBarAction(),
            ],
          ),
          body: Column(
            children: [
              SizedBox(height: size.height * 0.03),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ListProject(),
              ),
              SizedBox(height: size.height * 0.03),
              ListTabBar(),
            ],
          ),
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
                  child:
                      Icon(Icons.view_list, size: 36, color: tabBarBodyColor),
                  backgroundColor: goldenSecondary,
                )
              ],
            ),
          )),
    );
  }

  Future getHome() async {
    Home home = Home();
    String _home = await home.getHome();
    print(_home);

    setState(() {
      title = _home;
    });
  }
}
