import 'package:flutter/material.dart';

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

    List images = [
      'assets/images/Rectangle 2878.png',
      'assets/images/Rectangle 2870.png',
      'assets/images/Rectangle 2872.png',
      'assets/images/Rectangle 2873.png'
    ];

    return Row(
      children: [
        SizedBox(width: size.height * 0.03),
        CardListItem(
          title: title,
          imagePath: images[index],
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
