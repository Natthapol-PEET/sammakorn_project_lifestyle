import 'package:flutter/material.dart';
import '../../constance.dart';
import 'components/body.dart';

class AddLicensePlateScreen extends StatelessWidget {
  const AddLicensePlateScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Body(),
    );
  }
}
