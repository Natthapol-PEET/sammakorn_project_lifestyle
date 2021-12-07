import 'package:flutter/material.dart';

import '../../../constance.dart';
import 'card_list_item.dart';

class ListProject extends StatelessWidget {
  const ListProject({
    Key key,
    @required this.title,
    @required this.index,
  }) : super(key: key);

  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(width: size.height * 0.03),
        CardListItem(
          title: title,
          imagePath: projectImages[index],
        ),
        // SizedBox(width: size.height * 0.03),
        // CardListItem(
        //   title: 'บ้านสิรินธร 1/1',
        //   imagePath: images[0],
        // ),
        // SizedBox(width: size.height * 0.03),
      ],
    );
  }
}
