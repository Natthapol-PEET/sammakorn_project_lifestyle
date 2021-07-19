import 'dart:async';

import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/List_Item_All/service/service.dart';
import '../../constance.dart';
import 'components/list_item.dart';

class ListItemScreen extends StatefulWidget {
  const ListItemScreen({Key key}) : super(key: key);

  @override
  _ListItemScreenState createState() => _ListItemScreenState();
}

class _ListItemScreenState extends State<ListItemScreen> {
  Services services = Services();
  List whitelist_show = [];
  List blacklist_show = [];
  Timer timer;

  void initState() {
    super.initState();

    get_white_black();
    // timer = Timer.periodic(Duration(seconds: 3), (timer) {
    //   get_white_black();
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkgreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: goldenSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          "List Item",
          style: TextStyle(
            color: goldenSecondary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "WhiteList",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            build_whitelist_blacklist(context, Colors.green, whitelist_show),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "Blacklist",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            build_whitelist_blacklist(context, Colors.red, blacklist_show),
          ],
        ),
      ),
      backgroundColor: darkgreen200,
    );
  }

  Widget build_whitelist_blacklist(BuildContext context, Color color, lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListItem(
            title: lists[index]['license_plate'],
            descTime:
                "${lists[index]['firstname']}  ${lists[index]['lastname']}",
            color: color,
            pass: () {
              Services services = Services();
              services.deleteItem(
                  lists[index]['type'], lists[index]['id'].toString());
              get_white_black();
              Navigator.pop(context);
            },
          );
        });
  }

  get_white_black() {
    var data = services.getListItems();
    
    data.then((values) {
      List whitelist = values[0];
      List blacklist = values[1];

      setState(() {
        whitelist_show = whitelist;
        blacklist_show = blacklist;
      });
    });
  }

  void dispose() {
    super.dispose();
    // timer.cancel();
  }
}
