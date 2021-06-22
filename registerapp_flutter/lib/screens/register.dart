import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/screens/listitem.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String server_url = "http://192.168.1.177:8000";

  int _indexSelector = 0;

  List _colors = [
    [Colors.orange[300], Colors.white, Colors.white],
    [Colors.white, Colors.orange[300], Colors.white],
    [Colors.white, Colors.white, Colors.orange[300]],
  ];

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final carplatController = TextEditingController();
  final addressController = TextEditingController();

  String select_date = "เลือกวันที่";
  String start_time = "เวลาเริ่มต้น";
  String end_time = "เวลาสิ้นสุด";

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    carplatController.dispose();
    addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buttonGroup(),
            _indexSelector == 0
                ? visitor()
                : _indexSelector == 1
                    ? whitelist()
                    : blacklist(),
          ],
        ),
      ),
    );
  }

  Widget submitButton(String select) {
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: ButtonTheme(
        height: 40,
        minWidth: width - 50,
        child: RaisedButton(
          onPressed: () {
            postDataToServ(select);
          },
          color: Colors.orange[400],
          child: Text("Submit",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }

  Future postDataToServ(select) async {
    String firstname = firstnameController.text;
    String lastname = lastnameController.text;
    String carplat = carplatController.text;
    String address = addressController.text;

    var url, response;

    if (select == "visitor") {
      // visitor
      url = Uri.parse('${server_url}/register/visitor/');

      if (firstname.isEmpty ||
          lastname.isEmpty ||
          address.isEmpty ||
          carplat.isEmpty ||
          select_date == "เลือกวันที่" ||
          start_time == "เวลาเริ่มต้น" ||
          end_time == "เวลาสิ้นสุด") {
        _show_error_dialog();
      } else {
        response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "firstname": firstname,
            "lastname": lastname,
            "home_number": address,
            "license_plate": carplat,
            "date": select_date,
            "start_time": start_time,
            "end_time": end_time
          }),
        );

        if (response.statusCode == 201) {
          _show_seccess_dialog();
        }
      }
    } else if (select == "whitelist") {
      // whitelist
      if (firstname.isEmpty ||
          lastname.isEmpty ||
          address.isEmpty ||
          carplat.isEmpty) {
        _show_error_dialog();
      } else {
        url = Uri.parse('${server_url}/register/whitelist/');
        response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "firstname": firstname,
            "lastname": lastname,
            "home_number": address,
            "license_plate": carplat
          }),
        );

        if (response.statusCode == 201) {
          _show_seccess_dialog();
        }
      }
    } else {
      // blacklist
      if (firstname.isEmpty ||
          lastname.isEmpty ||
          address.isEmpty ||
          carplat.isEmpty) {
        _show_error_dialog();
      } else {
        url = Uri.parse('${server_url}/register/blacklist/');
        response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "firstname": firstname,
            "lastname": lastname,
            "home_number": address,
            "license_plate": carplat
          }),
        );

        if (response.statusCode == 201) {
          _show_seccess_dialog();
        }
      }
    }
  }

  _show_seccess_dialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'SUCCES',
      desc: 'บันทึกข้อมูลเรียบร้อย',
      // btnCancelOnPress: () {},
      btnOkOnPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ListItem(),
          ),
        );
      },
    )..show();
  }

  _show_error_dialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'ERROR',
      desc: 'กรุณากรอกข้อมูลให้ครบทุกช่อง',
      // btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
  }

  Widget visitor() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            inputFirstname(),
            inputLastname(),
            inputCarplate(),
            inputAddress(),
            inputDate(),
            inputTime(),
            submitButton("visitor"),
          ],
        ),
      ),
    );
  }

  Widget whitelist() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            inputFirstname(),
            inputLastname(),
            inputCarplate(),
            inputAddress(),
            submitButton("whitelist"),
          ],
        ),
      ),
    );
  }

  Widget blacklist() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            inputFirstname(),
            inputLastname(),
            inputCarplate(),
            inputAddress(),
            submitButton("blacklist"),
          ],
        ),
      ),
    );
  }

  Widget inputFirstname() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("First Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextField(
            controller: firstnameController,
            style: TextStyle(fontSize: 16, height: 1, color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputLastname() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Last Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextField(
            controller: lastnameController,
            style: TextStyle(fontSize: 16, height: 1, color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputCarplate() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Car Plate Number",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextField(
            controller: carplatController,
            style: TextStyle(fontSize: 16, height: 1, color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.car_rental),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputAddress() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Address Number",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextField(
            controller: addressController,
            style: TextStyle(fontSize: 16, height: 1, color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputDate() {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(
            width: size.width,
            height: size.height * 0.07,
            child: OutlineButton(
              child: Text(select_date, style: TextStyle(fontSize: 18)),
              onPressed: () {
                _select_date();
              },
            ),
          ),
        ],
      ),
    );
  }

  _select_date() {
    DatePicker.showDatePicker(context, showTitleActions: true,
        // minTime: DateTime(2018, 3, 5),
        // maxTime: DateTime(2026, 6, 7),
        // onChanged: (date) {
        // setState(() {
        //   pickeddate = "${date.day}";
        // });
        // },
        onConfirm: (date) {
      setState(() {
        select_date = "${date.year}-${date.month}-${date.day}";
      });
    }, currentTime: DateTime.now(), locale: LocaleType.th);
  }

  Widget inputTime() {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Time",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: size.height * 0.07,
                child: OutlineButton(
                  child: Text(start_time, style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    DatePicker.showTimePicker(context,
                        locale: LocaleType.th,
                        showTitleActions: true,
                        showSecondsColumn: false,
                        currentTime: DateTime.now(), onConfirm: (time) {
                      setState(() {
                        start_time = "${time.hour}:${time.minute}";
                      });
                    });
                  },
                ),
              ),
              Text(" - ", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: size.height * 0.07,
                child: OutlineButton(
                  child: Text(end_time, style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    DatePicker.showTimePicker(context,
                        locale: LocaleType.th,
                        showTitleActions: true,
                        showSecondsColumn: false,
                        currentTime: DateTime.now(), onConfirm: (time) {
                      setState(() {
                        end_time = "${time.hour}:${time.minute}";
                      });
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonGroup() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                setIndexSelected(0);
              },
              child: Text(
                "Visitor",
                style: TextStyle(fontSize: 16),
              ),
              color: _colors[_indexSelector][0],
            ),
            RaisedButton(
              onPressed: () {
                setIndexSelected(1);
              },
              child: Text(
                "Whitelist",
                style: TextStyle(fontSize: 16),
              ),
              color: _colors[_indexSelector][1],
            ),
            RaisedButton(
              onPressed: () {
                setIndexSelected(2);
              },
              child: Text(
                "Blacklist",
                style: TextStyle(fontSize: 16),
              ),
              color: _colors[_indexSelector][2],
            ),
          ],
        ),
      ),
    );
  }

  void setIndexSelected(index) {
    setState(() {
      _indexSelector = index;
    });
  }
}
