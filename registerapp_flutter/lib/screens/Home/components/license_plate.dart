import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/list_item_field_container.dart';
import 'package:registerapp_flutter/screens/Home/components/popup_body.dart';
import '../../../constance.dart';

class LicensePlate extends StatelessWidget {
  final Widget licensePlateInvite;
  final Widget build_comingAndWalk;
  final Widget build_hsaStamp;

  const LicensePlate({
    Key key,
    this.licensePlateInvite,
    this.build_comingAndWalk,
    this.build_hsaStamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Map lists = {
      'license_plate': 'license_plate',
      'fullname': 'fullname',
      'type': 'type',
      'datetime_in': 'datetime_in',
      'datetime_out': 'datetime_out'
    };

    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text("License Plate",
                    style: TextStyle(color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text("Status", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          // ListItemField(
          //   date: "8กฎ 8666",
          //   license_plate: "Invite",
          //   color: fededWhite1,
          //   press: () {
          //     _invite_dialog(context);
          //   },
          // ),
          licensePlateInvite,
          build_comingAndWalk,
          build_hsaStamp,
          // ListItemField(
          //   date: "8กฎ 8666",
          //   license_plate: "Coming in",
          //   color: greenYellow,
          //   press: () {
          //     _walkin_comingin_dialog(context, 'visitor');
          //   },
          // ),
          // ListItemField(
          //   date: "8กฎ 8666",
          //   license_plate: "Coming in",
          //   color: greenYellow,
          //   press: () {
          //     _walkin_comingin_dialog(context, 'whitelist');
          //   },
          // ),
          // ListItemField(
          //   date: "8กฎ 8666",
          //   license_plate: "Walk in",
          //   color: greenYellow,
          //   press: () {
          //     _walkin_comingin_dialog(context, 'visitor');
          //   },
          // ),
          // ListItemField(
          //   date: "6อบ 3265",
          //   license_plate: "HSA stamp",
          //   color: fededWhite,
          //   press: () {
          //     _sha_dialod(context);
          //   },
          // ),
          ListItemField(
            date: "6อบ 3265",
            license_plate: "PMS stamp",
            color: fededWhite,
            press: () {
              show_dialog(context, lists);
            },
          ),
        ],
      ),
    );
  }

  Widget show_dialog(BuildContext context, Map lists) {
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
