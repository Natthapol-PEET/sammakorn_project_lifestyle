import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/list_item_field_container.dart';
import 'package:registerapp_flutter/screens/Home/components/popup_body.dart';

import '../../../constance.dart';

class History extends StatelessWidget {
  final List history;

  const History({
    Key key,
    this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text("Date", style: TextStyle(color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text("License Plate",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          build_listview(context, history),
        ],
      ),
    );
  }

  Widget build_listview(BuildContext context, List lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListItemField(
            date: lists[index]['datetime_in'],
            license_plate: lists[index]['license_plate'],
            // color: lists[index]['type'] == 'whitelist'
            //     ? Colors.green.shade500
            //     : fededWhite,
            color: fededWhite,
            press: () {
              show_dialod(context, lists[index]);
            },
          );
        });
  }

  Widget show_dialod(BuildContext context, Map lists) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgDialog,
          content: Container(
            height: size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text("Mr. Teo\n", style: TextStyle(color: goldenSecondary)),
                    Text("${lists['license_plate']}\n",
                        style: TextStyle(color: goldenSecondary, fontSize: 18)),
                  ],
                ),
                Divider(
                  height: 5,
                  color: dividerColor,
                ),
                PopupBody(title: "Name", value: lists['fullname']),
                PopupBody(title: "Type", value: lists['type']),
                PopupBody(title: "Datetime in", value: lists['datetime_in']),
                PopupBody(title: "Datetime out", value: lists['datetime_out']),
              ],
            ),
          ),
          actions: [
            Center(
              child: ButtonTheme(
                minWidth: size.width * 0.5,
                child: OutlineButton(
                  highlightedBorderColor: goldenSecondary,
                  child: Text("Back", style: TextStyle(color: Colors.white)),
                  borderSide: BorderSide(
                    color: goldenSecondary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
