import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/list_item_field_container.dart';

import '../../../constance.dart';

class History extends StatelessWidget {
  const History({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: Text(
              "Date: 21-May-2021",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListItemField(
            date: "22-May-2021",
            license_plate: "8กฎ 8666",
            color: fededWhite,
            press: () {},
          ),
          ListItemField(
            date: "22-May-2021",
            license_plate: "8กฎ 8666",
            color: fededWhite,
            press: () {},
          ),
          SizedBox(height: size.height * 0.02),
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: Text(
              "Date: 21-May-2021",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListItemField(
            date: "22-May-2021",
            license_plate: "8กฎ 8666",
            color: fededWhite,
            press: () {},
          ),
          ListItemField(
            date: "22-May-2021",
            license_plate: "8กฎ 8666",
            color: fededWhite,
            press: () {},
          ),
        ],
      ),
    );
  }
}
