import 'package:flutter/material.dart';
import '../../../constance.dart';
import 'history.dart';
import 'license_plate.dart';

class BodytabBar extends StatelessWidget {
  const BodytabBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: tabBarBodyColor,
        child: TabBarView(
          children: [
            LicensePlate(),
            History(),
          ],
        ),
      ),
    );
  }
}

