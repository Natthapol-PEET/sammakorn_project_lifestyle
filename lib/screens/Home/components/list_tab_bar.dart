import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Home/components/title_tab_bar.dart';
import 'body_tab_bar.dart';

class ListTabBar extends StatelessWidget {
  final Widget build_licensePLateInvite;
  final Widget build_comingAndWalk;
  final Widget build_resident_stamp;
  final Widget build_resident_send_admin;
  final Widget build_pms_show;
  final Widget build_checkout;
  final Widget history;

  const ListTabBar({
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
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9,
      height: size.height * 0.697,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TitleTabBar(),
            BodytabBar(
              build_licensePLateInvite: build_licensePLateInvite,
              build_comingAndWalk: build_comingAndWalk,
              build_resident_stamp: build_resident_stamp,
              build_resident_send_admin: build_resident_send_admin,
              build_pms_show: build_pms_show,
              build_checkout: build_checkout,
              history: history,
            ),
          ],
        ),
      ),
    );
  }
}
