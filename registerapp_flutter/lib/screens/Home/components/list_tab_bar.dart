import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Home/components/title_tab_bar.dart';
import 'body_tab_bar.dart';

class ListTabBar extends StatelessWidget {
  final Widget build_licensePLateInvite;
  final Widget build_comingAndWalk;
  final Widget build_hsaStamp;

  final List history;

  const ListTabBar({
    Key key,
    this.history,
    this.build_licensePLateInvite,
    this.build_comingAndWalk,
    this.build_hsaStamp,
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
              build_hsaStamp: build_hsaStamp,
              history: history,
            ),
          ],
        ),
      ),
    );
  }
}
