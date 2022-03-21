import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Select_Home/service/update_home.dart';
import 'package:registerapp_flutter/screens/Notification/components/button_dialog.dart';

import '../../../constance.dart';
import 'card_list_item.dart';

class ListProject extends StatelessWidget {
  ListProject({
    Key key,
    @required this.title,
    @required this.index,
  }) : super(key: key);

  final String title;
  final int index;

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(width: size.height * 0.03),
        InkWell(
          onTap: () => dialogConfirm(
            context,
            'ไปที่โครงการ ${title}',
            () async {
              Home home = Home();

              // [API] GET home_id by home_name, home_number
              var data = await getHomeIdByRest(title);
              String homeId = data['home_id'].toString();
              String homeName = data['home_name'];

              // print("homeId >> ${homeId}");
              // print("homeName >> ${homeName}");
              // Update Home in sqlite3
              await home.updateHome(homeName, homeId);

              // update home rest
              await update_home_rest();

              // Reconnection MQTT
              Get.back();
              homeController.closeConnection();
              Future.delayed(Duration(milliseconds: 100), () async {
                await homeController.initMqtt();
                // Redirec Screen
                await homeController.getHome();
                // fetchApi
                await homeController.fetchApi();
                // success dialog
                success_dialog(context, 'เสร็จสิ้น');
                // pop dialog
                Future.delayed(Duration(milliseconds: 2000), () => Get.back());
              });
            },
          ),
          child: CardListItem(
            title: title,
            imagePath: projectImages[index],
          ),
        ),
        // SizedBox(width: size.height * 0.03),
        // CardListItem(
        //   title: 'บ้านสิรินธร 1/1',
        //   imagePath: images[0],
        // ),
        // SizedBox(width: size.height * 0.03),
      ],
    );
  }
}

Future<dynamic> dialogConfirm(
    BuildContext context, String text, Function press) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgDialog,
        title: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: dividerColor, fontFamily: 'Prompt'),
          ),
        ),
        actions: [
          if (true) ...[
            ButtonDialoog(
              text: "ยกเลิก",
              setBackgroudColor: false,
              press: () => Get.back(),
            )
          ],
          if (true) ...[
            ButtonDialoog(
              text: "ตกลง",
              setBackgroudColor: true,
              press: press,
            ),
          ],
        ],
      );
    },
  );
}

getHomeIdByRest(String title) async {
  Auth auth = Auth();
  Uri url = Uri.parse("${URL}/get_home_id/");
  var token_var = await auth.getToken();
  String token = 'Bearer ${token_var[0]["TOKEN"]}';

  String home_name = title.split(' - ')[0];
  String home_number = title.split(' - ')[1];

  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': token
    },
    body: jsonEncode(<String, String>{
      "home_name": home_name,
      "home_number": home_number,
    }),
  );

  // List object = [];

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    var lists = json.decode(body);

    print(lists);

    //   object = lists.toList();
    return lists;
  }

  // return object;
}
