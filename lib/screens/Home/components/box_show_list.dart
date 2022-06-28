import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/empty_componenmt.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/models/pack_data_model.dart';
import 'package:registerapp_flutter/models/screenArg.dart';
import 'package:registerapp_flutter/models/visitor_model.dart';
import 'package:registerapp_flutter/service/delete_invite.dart';
import 'package:registerapp_flutter/screens/ShowQrcode/showQrCodeScreen.dart';
import 'package:registerapp_flutter/functions/time__to_thai.dart';
import 'package:registerapp_flutter/service/resident_stamp.dart';
import '../../../constance.dart';
import 'card_list_timeline.dart';

class BoxShowList extends StatelessWidget {
  final List lists;
  final List? resident_send_admin, pms_show, checkout;
  final Color color;
  final String? select;
  final String? selectRSA, selectPMS, selectCO;

  final loginController = Get.put(LoginController());

  BoxShowList({
    Key? key,
    required this.lists,
    required this.color,
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

    // controller
    final controller = Get.put(HomeController());

    // String month_eng_to_thai

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
              ShowDateTime(),
              lists.length == 0
                  ? noHaveData(context, 'ไม่มีข้อมูล')
                  : builderList(context, lists),
            ],
          ),
        ),
      ),
    );
  }

  Widget builderList(context, lists) {
    final Size size = MediaQuery.of(context).size;

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: lists.length,
      itemBuilder: (context, index) {
        List<PackData> data = [];

        // create dummy invite
        if (lists[index] is VisitorModel)
          data.add(packData(lists[index].inviteDate, 'เชิญเข้ามาในโครงการ'));

        // create dummy comming and  wait stamp
        if (lists[index].datetimeIn != null) {
          data.add(packData(lists[index].datetimeIn, 'เข้ามาในโครงการแล้ว'));
          data.add(packData(lists[index].datetimeIn, 'รอแสตมป์ออกจากโครงการ'));
        }

        // create dummy resident stamp or admin stamp
        // if (lists[index].residentStamp != null || lists[index].adminStamp != null) {
        if (lists[index].residentStamp != null)
          data.add(
              packData(lists[index].residentStamp, 'แสตมป์ออกจากโครงการแล้ว'));

        // create dummy checkout
        if (lists[index].datetimeOut != null)
          data.add(packData(lists[index].datetimeOut, 'ออกจากโครงการแล้ว'));

        return GestureDetector(
          onTap: () {
            ScrollController _controller = ScrollController();
            SchedulerBinding.instance!.addPostFrameCallback((_) {
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
                            "เลขทะเบียนรถ : ${lists[index].licensePlate ?? '-'}"),
                        textFieldPopup(
                            "เลขประจำตัวประชาชน : ${lists[index].idCard ?? '-'}"),
                        textFieldPopup(
                            "ชื่อ-นามสกุล : ${lists[index].fullname ?? '-'}"),
                        textFieldPopup(
                            "ประเภท : ${lists[index].licensePlate != null ? 'รถ' : 'คน'}"),
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
                              return CardListTimeline(
                                date: data[index].date as String,
                                time: data[index].time as String,
                                text: data[index].text as String,
                                index: index,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    // if (lists[index].datetimeIn != null && (lists[index].residentStamp == null || lists[index].adminStamp == null)) ...[
                    if (lists[index].datetimeIn != null &&
                        lists[index].residentStamp == null) ...[
                      ButtonDialoog(
                        text: "แสตมป์",
                        icon: Icons.approval,
                        press: () {
                          residentStampApi(
                            loginController.dataLogin!.authToken as String,
                            lists[index].logId,
                            lists[index].homeId,
                          );

                          Get.back();
                          // dialog
                          successDialog(context, 'แสตมป์เรียบร้อย');

                          Timer(Duration(seconds: 2), () {
                            Get.back();
                          });
                        },
                      ),
                    ],
                    ButtonDialoog(
                      text: "คิวอาร์โค้ด",
                      icon: Icons.qr_code_2,
                      press: () {
                        Get.offAll(
                          () => ShowQrcodeScreen(
                            data: ScreenArguments(
                              lists[index].qrGenId ?? '-',
                              lists[index].inviteDate,
                              lists[index].idCard ?? '-',
                              lists[index].fullname ?? '-',
                              lists[index].licensePlate ?? '-',
                              lists[index].licensePlate == null ? 'คน' : 'รถ',
                            ),
                          ),
                        );
                      },
                    ),

                    if (lists[index].datetimeIn == null) ...[
                      ButtonDialoog(
                        text: "ลบ",
                        icon: Icons.delete,
                        press: () {
                          deleteInviteApi(
                            loginController.dataLogin!.authToken as String,
                            lists[index].visitorId,
                            lists[index].homeId,
                          );

                          Get.back();
                          successDialog(context, 'ลบรายการเชิญเรียบร้อย');

                          Timer(Duration(seconds: 2), () {
                            Get.back();
                          });
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
                            "เลขทะเบียนรถ : ${lists[index].licensePlate ?? '-'}"),
                        textField(
                            "เลขประจำตัวประชาชน : ${lists[index].idCard ?? '-'}"),
                        textField(
                            "ชื่อ-นามสกุล : ${lists[index].fullname ?? '-'}"),
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
class ShowDateTime extends StatelessWidget {
  ShowDateTime({
    Key? key,
  }) : super(key: key);

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String date =
        "วันที่ ${now.day} ${month_eng_to_thai(now.month)} ${christian_buddhist_year(now.year)}";

    return Padding(
      padding: const EdgeInsets.only(left: 21, top: 26, bottom: 26),
      child: Text(
        date,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Prompt',
          color: dividerColor,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ButtonDialoog extends StatelessWidget {
  const ButtonDialoog({
    required this.text,
    required this.icon,
    required this.press,
    Key? key,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Function()? press;

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

PackData packData(DateTime dt, String text) {
  return PackData(
    date:
        'วันที่ ${dt.day} ${month_eng_to_thai(dt.month)} ${christian_buddhist_year(dt.year)}',
    time: 'เวลา ${dt.hour}.${dt.minute} น.',
    text: text,
  );
}
