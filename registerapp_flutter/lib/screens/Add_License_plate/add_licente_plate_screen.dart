import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/service/service.dart';
import 'package:registerapp_flutter/screens/Home/home_screen.dart';
import '../../constance.dart';
import 'components/button_group.dart';
import 'components/date_input.dart';
import 'components/dropdown_item.dart';
import 'components/rount_input_field.dart';
import 'package:intl/intl.dart';

class AddLicensePlateScreen extends StatefulWidget {
  const AddLicensePlateScreen({Key key}) : super(key: key);

  @override
  _AddLicensePlateScreenState createState() => _AddLicensePlateScreenState();
}

class _AddLicensePlateScreenState extends State<AddLicensePlateScreen> {
  String classValue = "visitor";
  DateTime dateTime;
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final licenseplate = TextEditingController();

  Services services = Services();
  Home home = Home();

  void initState() {
    super.initState();
    dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: darkgreen200,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: goldenSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: darkgreen,
        title: Text(
          "Add License plate",
          style: TextStyle(color: goldenSecondary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownItem(
              chosenValue: classValue,
              onChanged: (value) {
                setState(() {
                  classValue = value;
                });
              },
            ),
            classValue == "visitor"
                ? DateInput(
                    date: DateFormat('dd-MM-yyyy').format(dateTime),
                    press: () => chooseDate(),
                  )
                : Container(),
            RoundInputField(
              title: "First Name",
              controller: firstname,
            ),
            RoundInputField(
              title: "Last Name",
              controller: lastname,
            ),
            RoundInputField(
              title: "License plate",
              controller: licenseplate,
            ),
            SizedBox(height: size.height * 0.1),
            ButtonGroup(
              save_press: () async {
                var Home = await home.getHomeAndId();
                // String homename = Home[0]["home"];
                String home_id = Home[0]["home_id"].toString();

                if (firstname.text.isNotEmpty &&
                    lastname.text.isNotEmpty &&
                    licenseplate.text.isNotEmpty) {
                  if (classValue == 'visitor') {
                    String res_text = await services.invite_visitor(
                        firstname.text,
                        lastname.text,
                        // homename,
                        home_id,
                        licenseplate.text,
                        DateFormat('yyyy-MM-dd').format(dateTime));
                    if (res_text == "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                      _move_to_home(context);
                    } else {
                      _show_error_toast(res_text);
                    }
                  } else if (classValue == 'whitelist') {
                    String res_text = await services.register_whitelist(
                      firstname.text,
                      lastname.text,
                      // homename,
                      home_id,
                      licenseplate.text,
                    );
                    if (res_text == "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                      _move_to_home(context);
                    } else {
                      _show_error_toast(res_text);
                    }
                  } else {
                    String res_text = await services.register_blacklist(
                      firstname.text,
                      lastname.text,
                      // homename,
                      home_id,
                      licenseplate.text,
                    );
                    if (res_text == "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                      _move_to_home(context);
                    } else {
                      _show_error_toast(res_text);
                    }
                  }
                } else {
                  _show_error_toast("กรุณาป้อนข้อมูลให้ครบทุกช่อง");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future chooseDate() async {
    DateTime chooseDateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: bgDialog),
          ),
          child: child,
        );
      },
    );

    if (chooseDateTime != null) {
      setState(() {
        dateTime = chooseDateTime;
      });
    }
  }

  _move_to_home(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      ),
    );
  }

  _show_error_toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  void dispose() {
    firstname.dispose();
    lastname.dispose();
    licenseplate.dispose();
    super.dispose();
  }
}
