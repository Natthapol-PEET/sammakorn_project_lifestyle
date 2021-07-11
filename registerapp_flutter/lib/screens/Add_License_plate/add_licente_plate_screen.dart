import 'package:flutter/material.dart';
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
            classValue == "visitor" ? DateInput(
              date: DateFormat('dd-MM-yyyy').format(dateTime),
              press: () => chooseDate(),
            ) : Container(),
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
              save_press: () {
                print(classValue);
                print(DateFormat('dd-MM-yyyy').format(dateTime));
                print(firstname.text);
                print(lastname.text);
                print(licenseplate.text);
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

  @override
  void dispose() {
    firstname.dispose();
    lastname.dispose();
    licenseplate.dispose();
    super.dispose();
  }
}
