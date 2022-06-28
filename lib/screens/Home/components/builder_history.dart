import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/empty_componenmt.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/functions/xscc.dart';
import '../../../constance.dart';

// ignore: must_be_immutable
class BoxShowListHistory extends StatelessWidget {
  final List lists;
  final Color color;

  BoxShowListHistory({
    Key? key,
    required this.lists,
    required this.color,
  }) : super(key: key);

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: size.height * 0.025),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.06,
        vertical: size.height * 0.03,
      ),
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
              padding: EdgeInsets.all(0),
              child: Row(
                children: [
                  Text(
                    "เดือน",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 18,
                      color: dividerColor,
                    ),
                  ),

                  // Dropdown
                  Container(
                    margin: EdgeInsets.only(left: size.width * 0.02),
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.03),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: darkgreen200,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: darkgreen200,
                        ),
                        child: Obx(
                          () => DropdownButton(
                              value: homeController.dropdowValue.value,
                              items: listMonth.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Prompt',
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (v) => homeController.updateDropdown(
                                  mapMonth, v.toString())),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            lists.length == 0
                ? noHaveData(context, 'ไม่มีข้อมูล')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(top: size.height * 0.02),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textField(
                                  "วันที่นัดหมาย : ${lists[index].historyCreateDT}"),
                              textField(
                                  "เลขทะเบียนรถ : ${lists[index].licensePlate ?? '-'}"),
                              textField(
                                  "เลขประจำตัวประชาชน : ${lists[index].idCard ?? '-'}"),
                              textField(
                                  "ชื่อ-นามสกุล : ${lists[index].fullname ?? '-'}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Text textField(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Prompt',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
