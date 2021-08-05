import 'package:flutter/material.dart';
import '../../../constance.dart';
import 'history.dart';
import 'license_plate.dart';

class BodytabBar extends StatelessWidget {
  final Widget build_licensePLateInvite;
  final Widget build_comingAndWalk;
  final Widget build_resident_stamp;
  final Widget build_resident_send_admin;
  final Widget build_pms_show;
  final Widget build_checkout;
  final Widget history;

  const BodytabBar({
    Key key,
    this.history,
    this.build_licensePLateInvite,
    this.build_comingAndWalk,
    this.build_resident_stamp,
    this.build_pms_show,
    this.build_resident_send_admin,
    this.build_checkout,
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
              build_resident_stamp: build_resident_stamp,
              build_resident_send_admin: build_resident_send_admin,
              build_pms_show: build_pms_show,
              build_checkout: build_checkout,
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
