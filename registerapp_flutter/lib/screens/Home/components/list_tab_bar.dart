import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Home/components/title_tab_bar.dart';
import 'body_tab_bar.dart';

class ListTabBar extends StatelessWidget {
  const ListTabBar({
    Key key,
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
            BodytabBar()
          ],
        ),
      ),
    );
  }
}

