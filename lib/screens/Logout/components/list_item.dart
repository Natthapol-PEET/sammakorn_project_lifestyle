import 'package:flutter/material.dart';

import '../../../constance.dart';

class ListItem extends StatelessWidget {
  final Function()? press;
  final String title;
  final String desc;

  const ListItem({
    Key? key,
    this.press,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.08,
          decoration: BoxDecoration(
            color: backgrounditem,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: goldenSecondary,
                    fontSize: 18,
                    fontFamily: 'Prompt',
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Prompt',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
