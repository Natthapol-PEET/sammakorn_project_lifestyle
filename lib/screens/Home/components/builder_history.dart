import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/empty_componenmt.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import '../../../constance.dart';

// ignore: must_be_immutable
class BoxShowListHistory extends StatelessWidget {
  final List lists;
  final Color color;
  final String select;

  BoxShowListHistory({
    Key key,
    @required this.lists,
    @required this.color,
    this.select,
  }) : super(key: key);

  String dateStr = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // final date = DateFormat('dd-MMMM-yyyy').format(DateTime.now());
    DateTime datetime = DateTime.now();

    String year = ((datetime.year + 543) - 2500).toString();

    List<String> listMonth = [
      "มกราคม ${year}",
      "กุมภาพันธ์ ${year}",
      "มีนาคม ${year}",
      "เมษายน ${year}",
      "พฤษภาคม ${year}",
      "มิถุนายน ${year}",
      "กรกฎาคม ${year}",
      "สิงหาคม ${year}",
      "กันยายน ${year}",
      "ตุลาคม ${year}",
      "พฤศจิกายน ${year}",
      "ธันวาคม ${year}",
    ];

    Map<int, String> mapMonth = {
      1: "มกราคม ${year}",
      2: "กุมภาพันธ์ ${year}",
      3: "มีนาคม ${year}",
      4: "เมษายน ${year}",
      5: "พฤษภาคม ${year}",
      6: "มิถุนายน ${year}",
      7: "กรกฎาคม ${year}",
      8: "สิงหาคม ${year}",
      9: "กันยายน ${year}",
      10: "ตุลาคม ${year}",
      11: "พฤศจิกายน ${year}",
      12: "ธันวาคม ${year}",
    };

    final homeController = Get.put(HomeController());

    homeController.dropdowValue.value = mapMonth[datetime.month];

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
                              onChanged: (value) {
                                homeController.dropdowValue.value = value;

                                var monthKey = mapMonth.keys.firstWhere(
                                    (k) => mapMonth[k] == value,
                                    orElse: () => null);

                                homeController.findDataInMonth(monthKey, lists);
                              }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            GetBuilder<HomeController>(
              builder: (_) => homeController.history_data.length == 0
                  ? noHaveData(context, 'ไม่มีข้อมูล')
                  : Container(),
            ),

            GetBuilder<HomeController>(
              builder: (_) => ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: homeController.history_data.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = homeController.history_data[index];

                  return // Card show detail
                      Container(
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
                          textField("วันที่นัดหมาย : ${data['date']}"),
                          textField("เลขทะเบียนรถ : ${data['license']}"),
                          textField(
                              "เลขประจำตัวประชาชน : ${data['id_card'] != null ? data['id_card'] : '-'}"),
                          textField("ชื่อ-นามสกุล : ${data['fullname']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // builderList(context, lists, select),
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

  // Padding dateTitle(String dateFormat) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 21, top: 26, bottom: 15),
  //     child: Text(
  //       dateFormat,
  //       style: TextStyle(
  //         fontSize: 18,
  //         color: Colors.white,
  //         fontFamily: 'Prompt',
  //       ),
  //     ),
  //   );
  // }

  // GestureDetector listItem(
  //     lists, int index, select, BuildContext context, Size size) {
  //   return GestureDetector(
  //     onTap: () {
  //       lists[index]['select'] = select;
  //       Navigator.pushNamed(context, '/show_detail', arguments: lists[index]);
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //       child: Container(
  //         height: 65,
  //         width: size.width,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: Colors.white,
  //         ),
  //         child: Stack(
  //           children: [
  //             Container(
  //               width: 8,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(15),
  //                     bottomLeft: Radius.circular(15)),
  //                 color: color,
  //               ),
  //             ),
  //             Positioned(
  //               top: 5,
  //               right: 10,
  //               child:
  //                   Text("Status: ${select}", style: TextStyle(color: color)),
  //             ),
  //             Positioned(
  //               top: 10,
  //               left: 30,
  //               child: Text(
  //                 lists[index]['license_plate'],
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               bottom: 10,
  //               left: 30,
  //               child: Text(
  //                 lists[index]['fullname'],
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // ListView builderList(context, lists, select) {
  //   final Size size = MediaQuery.of(context).size;

  //   return ListView.builder(
  //     physics: NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: lists.length,
  //     itemBuilder: (context, index) {
  //       String date = lists[index]['datetime_out'].split('T')[0];
  //       String time = lists[index]['datetime_out'].split('T')[1];
  //       DateTime dt = DateTime.parse(date + ' ' + time);
  //       final dateFormat = DateFormat('dd-MMMM-yyyy').format(dt);

  //       if (dateFormat != dateStr) {
  //         dateStr = dateFormat;

  //         return SingleChildScrollView(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // DateTitle(dateFormat),
  //               DateTitle(
  //                   "วันที่ ${dt.day} ${month_eng_to_thai(dt.month)} ${christian_buddhist_year(dt.year)}"),
  //               ListItem(lists, index, select, context, size),
  //             ],
  //           ),
  //         );
  //       } else {
  //         return GestureDetector(
  //           onTap: () {
  //             lists[index]['select'] = select;
  //             Navigator.pushNamed(context, '/show_detail',
  //                 arguments: lists[index]);
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //             child: Container(
  //               height: 65,
  //               width: size.width,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 color: Colors.white,
  //               ),
  //               child: Stack(
  //                 children: [
  //                   Container(
  //                     width: 8,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(15),
  //                           bottomLeft: Radius.circular(15)),
  //                       color: color,
  //                     ),
  //                   ),
  //                   Positioned(
  //                     top: 5,
  //                     right: 10,
  //                     child: Text("Status: ${select}",
  //                         style: TextStyle(color: color)),
  //                   ),
  //                   Positioned(
  //                     top: 10,
  //                     left: 30,
  //                     child: Text(
  //                       lists[index]['license_plate'],
  //                       style: TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     bottom: 10,
  //                     left: 30,
  //                     child: Text(
  //                       lists[index]['fullname'],
  //                       style: TextStyle(
  //                         fontSize: 18,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       } // else
  //     },
  //   );
  // }
}
