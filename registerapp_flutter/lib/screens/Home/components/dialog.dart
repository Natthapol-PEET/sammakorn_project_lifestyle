import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Home/components/popup_body.dart';
import 'package:registerapp_flutter/screens/Home/components/show_button_group.dart';
import 'package:registerapp_flutter/screens/Home/components/stamp_button_group.dart';
import '../../../constance.dart';
import 'legal_button_group.dart';

class PopupDialog {
  invite_dialog(BuildContext context, Map lists, Function pass) {
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
                    Text("${lists['license_plate']}\n",
                        style: TextStyle(color: goldenSecondary, fontSize: 18)),
                  ],
                ),
                Divider(
                  height: 3,
                  color: dividerColor,
                ),
                PopupBody(title: "Name", value: lists['fullname']),
                PopupBody(title: "Type", value: lists['type']),
                PopupBody(title: "Invited", value: lists['datetime']),
              ],
            ),
          ),
          actions: [
            ShowButtonGroup(
              pass: pass,
            ),
          ],
        );
      },
    );
  }

  Widget walkin_comingin_dialog(
      BuildContext context, Map lists, Function pass) {
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
                    Text("${lists['license_plate']}\n",
                        style: TextStyle(color: goldenSecondary, fontSize: 18)),
                  ],
                ),
                Divider(
                  height: 3,
                  color: dividerColor,
                ),
                PopupBody(title: "Name", value: lists['fullname']),
                PopupBody(title: "Type", value: lists['type']),
                PopupBody(title: "Invited", value: lists['invite_date']),
                PopupBody(title: lists['status'], value: lists['datetime_in']),
              ],
            ),
          ),
          actions: [
            StampButtonGroup(
              pass: pass,
            ),
          ],
        );
      },
    );
  }

  Widget resident_dialod(BuildContext context, Map lists, Function pass) {
    Size size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgDialog,
          content: Container(
            height: size.height * 0.5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${lists['license_plate']}\n",
                          style:
                              TextStyle(color: goldenSecondary, fontSize: 18)),
                    ],
                  ),
                  Divider(
                    height: 5,
                    color: dividerColor,
                  ),
                  PopupBody(title: "Name", value: lists['fullname']),
                  PopupBody(title: "Type", value: lists['type']),
                  PopupBody(title: "Invite", value: lists['invite']),
                  PopupBody(
                      title: lists['status'], value: lists['datetime_in']),
                  PopupBody(title: "HSA Stamp", value: lists['resident_stamp']),
                  true
                      ? PopupBody(
                          title: "จำนวนครั้งที่สามารถสแตมป์ได้",
                          value: lists['stamp_count'].toString())
                      : PopupBody(title: "เวลาที่เหลือ", value: "1.30 ชม"),
                  SizedBox(height: 10),
                  Text('ส่งคำขอเพื่อให้นิติบุคคลสแตมป์ ?',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          actions: [
            LegalButtonGroup(
              pass: pass,
            ),
          ],
        );
      },
    );
  }
}
