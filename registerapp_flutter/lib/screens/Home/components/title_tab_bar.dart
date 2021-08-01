import 'package:flutter/material.dart';
import '../../../constance.dart';

class TitleTabBar extends StatelessWidget {
  const TitleTabBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: darkgreen,
        ),
        constraints: BoxConstraints.expand(height: 50),
        child: TabBar(
          labelColor: goldenSecondary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: goldenSecondary,
          automaticIndicatorColorAdjustment: false,
          indicatorWeight: 4,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelStyle:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: [
            Tab(text: "Whlite List"),
            Tab(text: "Black List"),
          ],
        ),
      ),
    );
  }
}
