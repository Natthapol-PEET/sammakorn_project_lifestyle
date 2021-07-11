import 'package:flutter/material.dart';

import 'card_list_item.dart';

class ListProject extends StatelessWidget {
  const ListProject({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(width: size.height * 0.03),
        CardListItem(
          title: 'บ้านสิรินธร 1/1',
          imagePath: 'assets/images/Rectangle 2878.png',
        ),
        SizedBox(width: size.height * 0.03),
        CardListItem(
          title: 'บ้านสิรินธร 1/2',
          imagePath: 'assets/images/Rectangle 2870.png',
        ),
        SizedBox(width: size.height * 0.03),
        CardListItem(
          title: 'บ้านไลฟ์สไตล์ 2/1',
          imagePath: 'assets/images/Rectangle 2872.png',
        ),
        SizedBox(width: size.height * 0.03),
        CardListItem(
          title: 'บ้านไลฟ์สไตล์ 2/2',
          imagePath: 'assets/images/Rectangle 2873.png',
        ),
        SizedBox(width: size.height * 0.03),
      ],
    );
  }
}
