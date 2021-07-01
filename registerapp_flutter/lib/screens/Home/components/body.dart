import 'package:flutter/material.dart';
import 'list_project.dart';
import 'list_tab_bar.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.03),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ListProject(),
        ),
        SizedBox(height: size.height * 0.03),
        ListTabBar(),
      ],
    );
  }
}
