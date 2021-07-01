import 'package:flutter/material.dart';
import '../../../constance.dart';

class TitleTabBar extends StatelessWidget {
  const TitleTabBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
        color: tabBarColor,
      ),
      constraints: BoxConstraints.expand(height: 50),
      child: TabBar(
        labelColor: goldenSecondary,
        unselectedLabelColor: Colors.grey,
        indicatorColor: goldenSecondary,
        automaticIndicatorColorAdjustment: false,
        tabs: [
          Tab(text: "License Plate"),
          Tab(text: "History"),
        ],
      ),
    );
  }
}
