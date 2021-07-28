import 'package:flutter/material.dart';
import '../../constance.dart';
import 'components/dropdown_item.dart';
import 'package:registerapp_flutter/screens/Select_Home/service/service.dart';
import 'package:registerapp_flutter/data/home.dart';

class SelectHomeScreen extends StatefulWidget {
  const SelectHomeScreen({Key key}) : super(key: key);

  @override
  _SelectHomeScreenState createState() => _SelectHomeScreenState();
}

class _SelectHomeScreenState extends State<SelectHomeScreen> {
  Services services = Services();
  Home home = Home();

  List home_ids = [];
  List listItem = [];
  String selectHome;

  @override
  void initState() {
    super.initState();

    getHome();
  }

  getHome() async {
    var data = await services.getHome();
    var allHome = data[0], home_id = data[1];

    if (allHome == -1) {
      print("services error");
    } else {
      setState(() {
        selectHome = allHome[0];
        listItem = allHome;
        home_ids = home_id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkgreen,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownItem(
            listItem: listItem,
            chosenValue: selectHome,
            onChanged: (value) {
              setState(() {
                selectHome = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(greenYellow)),
            onPressed: () {
              // updateHome
              int find_id =
                  listItem.indexWhere((item) => item.startsWith(selectHome));
              home.updateHome(selectHome, home_ids[find_id].toString());

              Navigator.pushNamed(context, '/home');
            },
            child: Text('Go to home'),
          ),
        ],
      ),
    );
  }
}
