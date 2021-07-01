import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/list_item_field_container.dart';
import 'package:registerapp_flutter/screens/Home/components/popup_body.dart';
import 'package:registerapp_flutter/screens/Home/components/stamp_button_group.dart';

import '../../../constance.dart';
import 'legal_button_group.dart';

class LicensePlate extends StatelessWidget {
  const LicensePlate({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
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
          ListItemField(
            date: "22-May-2021",
            license_plate: "8กฎ 8666",
            color: greenYellow,
            press: () {
              _stamp_dialod(context);
            },
          ),
          ListItemField(
            date: "22-May-2021",
            license_plate: "6อบ 3265",
            color: fededWhite,
            press: () {
              _legal_stamp_dialod(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _stamp_dialod(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Mr. Teo\n", style: TextStyle(color: goldenSecondary)),
                    Text("45กด 5689\n",
                        style: TextStyle(color: goldenSecondary)),
                  ],
                ),
                Divider(
                  height: 5,
                  color: dividerColor,
                ),
                PopupBody(title: "Name", value: "Mr. Teo"),
                PopupBody(title: "Type", value: "Visitor"),
                PopupBody(title: "Date", value: "22-May-2021 : 15.30 pm"),
              ],
            ),
          ),
          actions: [
            StampButtonGroup(),
          ],
        );
      },
    );
  }

  Widget _legal_stamp_dialod(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Mr. Teo\n", style: TextStyle(color: goldenSecondary)),
                    Text("45กด 5689\n",
                        style: TextStyle(color: goldenSecondary)),
                  ],
                ),
                Divider(
                  height: 5,
                  color: dividerColor,
                ),
                PopupBody(title: "Name", value: "Mr. Teo"),
                PopupBody(title: "Type", value: "Visitor"),
                PopupBody(title: "Date", value: "22-May-2021 : 15.30 pm"),
                false
                    ? PopupBody(title: "จำนวนครั้งที่เหลือ (Stamp)", value: "2")
                    : PopupBody(title: "เวลาที่เหลือ", value: "1.30 ชม"),
              ],
            ),
          ),
          actions: [
            LegalButtonGroup(),
          ],
        );
      },
    );
  }
}
