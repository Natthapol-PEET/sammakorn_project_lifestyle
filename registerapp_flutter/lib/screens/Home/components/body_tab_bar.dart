import 'package:flutter/material.dart';
import '../../../constance.dart';
import 'history.dart';
import 'license_plate.dart';

class BodytabBar extends StatelessWidget {
  final List history;
  final Widget build_licensePLateInvite;
  final Widget build_comingAndWalk;
  final Widget build_hsaStamp;

  const BodytabBar({
    Key key,
    this.history,
    this.build_licensePLateInvite,
    this.build_comingAndWalk,
    this.build_hsaStamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: tabBarBodyColor,
        child: TabBarView(
          children: [
            LicensePlate(
              licensePlateInvite: build_licensePLateInvite,
              build_comingAndWalk: build_comingAndWalk,
              build_hsaStamp: build_hsaStamp,
            ),
            History(
              history: history,
            ),
          ],
        ),
      ),
    );
  }
}
