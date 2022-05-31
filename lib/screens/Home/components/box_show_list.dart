import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/empty_componenmt.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/models/screenArg.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import 'package:registerapp_flutter/screens/ShowDetailScreen/components/card_list_timeline.dart';
import 'package:registerapp_flutter/screens/ShowQrcode/showQrCodeScreen.dart';
import 'package:registerapp_flutter/utils/time__to_thai.dart';
import '../../../constance.dart';

class BoxShowList extends StatelessWidget {
  final List lists, resident_send_admin, pms_show, checkout;
  final Color color;
  final String select;
  final String selectRSA, selectPMS, selectCO;

  final loginController = Get.put(LoginController());

  BoxShowList({
    Key key,
    @required this.lists,
    @required this.color,
    this.select,
    this.resident_send_admin,
    this.pms_show,
    this.checkout,
    this.selectRSA,
    this.selectPMS,
    this.selectCO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // final date = DateFormat('dd-MMMM-yyyy').format(DateTime.now());
    DateTime now = DateTime.now();

    // controller
    final controller = Get.put(HomeController());

    // String month_eng_to_thai
    String date =
        "วันที่ ${now.day} ${month_eng_to_thai(now.month)} ${christian_buddhist_year(now.year)}";

    // String select = "Invite";
    // List lists = [
    //   {
    //     "license_plate": "123asd",
    //     "id_card": "1410501130726",
    //     "fullname": "Mr.Natthapol Nonthasri",
    //     "type": "รถ",
    //     "invite_datetime": "วันที่ 15 ธันวาคม 2564 , 11.30 น.",
    //     "comming_datetime": "วันที่ 15 ธันวาคม 2564 , 12.30 น.",
    //   },
    // ];

    // List pms_show = [
    //   {
    //     "license_plate": "บล3212",
    //     "id_card": "1410501130726",
    //     "fullname": "นายนัฐพล  นนทะศรี",
    //     "type": "รถ",
    //     "invite_datetime": "วันที่ 22 พฤษภาคม 2564 , 11.30 น.",
    //     // "comming_datetime": "วันที่ 22 พฤษภาคม 2564 , 12.30 น.",
    //   },
    // ];

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: size.height * 0.72,
        width: size.width,
        decoration: BoxDecoration(
          color: darkgreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 21, top: 26, bottom: 26),
                // child: Text('Date ${date}',
                child: Text(
                  // dateInBuddhistCalendarFormat,
                  date,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Prompt',
                    color: dividerColor,
                  ),
                ),
              ),
              if (select != "Resident stamp") ...[
                // Empty
                if (lists.length == 0) ...[noHaveData(context, 'ไม่มีข้อมูล')],

                // Not Empty
                builderList(context, lists, select, controller),
              ],
              if (select == "Resident stamp") ...[
                // Empty
                if ((lists.length +
                        resident_send_admin.length +
                        pms_show.length +
                        checkout.length) ==
                    0) ...[noHaveData(context, 'ไม่มีข้อมูล')],

                // Not Empty
                builderList(context, lists, select, controller),
                builderList(
                    context, resident_send_admin, selectRSA, controller),
                builderList(context, pms_show, selectPMS, controller),
                builderList(context, checkout, selectCO, controller)
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget builderList(context, lists, select, controller) {
    final Size size = MediaQuery.of(context).size;

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: lists.length,
      itemBuilder: (context, index) {
        List data = [];

        if (lists[index].containsKey('invite')) {
          if (lists[index]['invite'] != null) {
            Map d = packData(lists[index]['invite'], 'เชิญเข้ามาในโครงการ');
            data.add(d);
          }
        }

        if (lists[index].containsKey('datetime_in')) {
          if (lists[index]['datetime_in'] != null) {
            Map d =
                packData(lists[index]['datetime_in'], 'เข้ามาในโครงการแล้ว');
            data.add(d);
          }

          if (lists[index]['license_plate'] != null) {
            if (lists[index]['license_plate'] != null) {
              if (lists[index]['license_plate'] != null) {
                Map d = packData(
                    lists[index]['datetime_in'], 'รอแสตมป์ออกจากโครงการ');
                data.add(d);
              }
            }
          }
        }

        if (lists[index].containsKey('resident_stamp')) {
          if (lists[index]['resident_stamp'] != null) {
            Map d = packData(
                lists[index]['resident_stamp'], 'แสตมป์ออกจากโครงการแล้ว');
            data.add(d);
          }
        }

        if (lists[index].containsKey('datetime_out')) {
          if (lists[index]['datetime_out'] != null) {
            Map d = packData(lists[index]['datetime_out'], 'ออกจากโครงการแล้ว');
            data.add(d);
          }
        }

        return GestureDetector(
          onTap: () {
            ScrollController _controller = ScrollController();

            // SchedulerBinding.instance.addPostFrameCallback((_) {
            //   _controller.jumpTo(_controller.position.maxScrollExtent);
            // });

            SchedulerBinding.instance.addPostFrameCallback((_) {
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            });

            // popup show detail
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: bgDialog,
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "รายละเอียด",
                            style: TextStyle(
                                fontSize: 18,
                                color: dividerColor,
                                fontFamily: 'Prompt'),
                          ),
                          GestureDetector(
                              onTap: () => Get.back(),
                              child: Icon(Icons.close, color: dividerColor)),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Divider(color: dividerColor),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFieldPopup(
                            "เลขทะเบียนรถ : ${lists[index]['license_plate'] != null ? lists[index]['license_plate'] : '-'}"),
                        textFieldPopup(
                            "เลขประจำตัวประชาชน : ${lists[index]['id_card'] != null ? lists[index]['id_card'] : '-'}"),
                        textFieldPopup(
                            "ชื่อ-นามสกุล : ${lists[index]['fullname']}"),
                        textFieldPopup(
                            "ประเภท : ${lists[index]['license_plate'] != null ? 'รถ' : 'คน'}"),
                        SizedBox(height: size.height * 0.03),

                        // timeline
                        Container(
                          height: 200,
                          width: 300,
                          child: ListView.builder(
                            controller: _controller,
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              /*
                              date: วันที่ 22 พฤษภาคม 2564
                              time: เวลา 11.30 น.
                              text: เชิญเข้ามาในโครงการ
                              index: 1
                            */
                              // List data = [
                              //   {
                              //     'date': 'วันที่ 22 พฤษภาคม 2564',
                              //     'time': 'เวลา 11.30 น.',
                              //     'text': 'เชิญเข้ามาในโครงการ',
                              //   },
                              //   {
                              //     'date': 'วันที่ 22 พฤษภาคม 2564',
                              //     'time': 'เวลา 12.00 น.',
                              //     'text': 'รถเข้ามาในโครงการแล้ว',
                              //   },
                              //   {
                              //     'date': 'วันที่ 22 พฤษภาคม 2564',
                              //     'time': 'เวลา 12.00 น.',
                              //     'text': 'รอแสตมป์ออกจากโครงการ',
                              //   },
                              //   {
                              //     'date': 'วันที่ 22 พฤษภาคม 2564',
                              //     'time': 'เวลา 12.00 น.',
                              //     'text': 'แสตมป์ออกจากโครงการแล้ว',
                              //   },
                              //   {
                              //     'date': 'วันที่ 22 พฤษภาคม 2564',
                              //     'time': 'เวลา 12.00 น.',
                              //     'text': 'ออกจากโครงการแล้ว',
                              //   }
                              // ];

                              return CardListTimeline(
                                date: data[index]['date'],
                                time: data[index]['time'],
                                text: data[index]['text'],
                                index: index,
                              );

                              // print(data[index]['date']);
                              // return Container();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    if (select == 'Invite') ...[
                      ButtonDialoog(
                        text: "คิวอาร์โค้ด",
                        icon: Icons.qr_code_2,
                        press: () {
                          Get.offAll(
                            () => ShowQrcodeScreen(
                              data: ScreenArguments(
                                lists[index]['qr_gen_id'],
                                lists[index]['invite'].split('T')[
                                    0], // DateFormat('yyyy-MM-dd').format(dateTime),
                                lists[index]['id_card'] != null
                                    ? lists[index]['id_card']
                                    : '-',
                                lists[index]['fullname'],
                                lists[index]['license_plate'],
                                lists[index]['license_plate'] != null
                                    ? 'รถ'
                                    : 'คน', // addController.classValue.value,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                    if (select == 'coming_walk') ...[
                      ButtonDialoog(
                        text: "แสตมป์",
                        icon: Icons.approval,
                        press: () {
                          residentStampApi(loginController.dataLogin.authToken,
                              lists[index]['log_id'].toString());

                          // update
                          controller.publishMqtt(
                              "app-to-app", "RESIDENT_STAMP");
                          controller.publishMqtt(
                              "app-to-web", "RESIDENT_STAMP");

                          // dialog
                          success_dialog(context, 'แสตมป์เรียบร้อย');

                          Timer(Duration(seconds: 2), () {
                            Get.back();
                            Get.back();
                          });
                        },
                      ),
                    ],
                    if (select == 'Invite') ...[
                      ButtonDialoog(
                        text: "ลบ",
                        icon: Icons.delete,
                        press: () {
                          deleteInviteApi(loginController.dataLogin.authToken,
                              lists[index]['visitor_id'].toString());

                          // update
                          controller.publishMqtt(
                              "app-to-app", "INVITE_VISITOR");
                          controller.publishMqtt(
                              "app-to-web", "INVITE_VISITOR");

                          Get.back();
                        },
                      )
                    ],
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.01),
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.03,
                    height: size.height * 0.12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: color,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.01,
                        horizontal: size.width * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textField(
                            "เลขทะเบียนรถ : ${lists[index]['license_plate'] != null ? lists[index]['license_plate'] : '-'}"),
                        textField(
                            "เลขประจำตัวประชาชน : ${lists[index]['id_card'] != null ? lists[index]['id_card'] : '-'}"),
                        textField("ชื่อ-นามสกุล : ${lists[index]['fullname']}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Text textFieldPopup(String text) {
    return Text(
      text,
      // overflow: TextOverflow.fade,
      overflow: TextOverflow.clip,
      maxLines: 1,
      softWrap: false,
      style: TextStyle(
        fontFamily: 'Prompt',
        color: dividerColor,
        fontSize: 16,
      ),
    );
  }

  Text textField(String text) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Prompt',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ignore: must_be_immutable
class ButtonDialoog extends StatelessWidget {
  const ButtonDialoog({
    @required this.text,
    @required this.icon,
    @required this.press,
    Key key,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Function press;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(
        left: size.width * 0.08,
        right: size.width * 0.08,
        bottom: size.height * 0.015,
      ),
      child: ButtonTheme(
        height: size.height * 0.06,
        child: OutlineButton(
          highlightedBorderColor: goldenSecondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: goldenSecondary),
              Text(text,
                  style: TextStyle(
                    color: goldenSecondary,
                    fontSize: 16,
                    fontFamily: 'Prompt',
                  )),
            ],
          ),
          borderSide: BorderSide(
            color: goldenSecondary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: press,
        ),
      ),
    );
  }
}

Map packData(String datetime, String text) {
  String inviteDateTime = datetime;

  print('text: $text || inviteDateTime: $inviteDateTime');
  if (inviteDateTime[0] == 'T') {
    final now = DateTime.now();

    inviteDateTime = "${now.year}-${now.month}-${now.day}$inviteDateTime";
  }

  if (inviteDateTime == null) {
    return {};
  }

  List inviteList = inviteDateTime.split('-');
  List inviteSplitT = inviteList[2].split('T');

  int date = int.parse(inviteSplitT[0]);
  int month = int.parse(inviteList[1]);
  int year = int.parse(inviteList[0]);

  String hour = inviteSplitT[1].split(':')[0];
  String minute = inviteSplitT[1].split(':')[1];

  return {
    'date':
        'วันที่ ${date} ${month_eng_to_thai(month)} ${christian_buddhist_year(year)}',
    'time': 'เวลา ${hour}.${minute} น.',
    'text': text,
  };

  // return {
  //   'date': 'วันที่ ',
  //   'time': 'เวลา  น.',
  //   'text': text,
  // };
}
