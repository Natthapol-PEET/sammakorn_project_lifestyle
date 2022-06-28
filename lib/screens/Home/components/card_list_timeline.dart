import 'package:flutter/material.dart';
import '../../../constance.dart';

class CardListTimeline extends StatelessWidget {
  CardListTimeline({
    Key? key,
    required this.date,
    required this.time,
    required this.text,
    required this.index,
  }) : super(key: key);

  final String date;
  final String time;
  final String text;
  final int index;

  @override
  Widget build(BuildContext context) {
    List colors = [
      inviteColor,
      comingColor,
      infrontColor,
      stampColor,
      outColor,
      Colors.yellow,
      Colors.yellow,
      Colors.yellow,
      Colors.green
    ];

    Size size = MediaQuery.of(context).size;

    return Container(
      child: Row(
        children: [
          Column(
            children: [
              // circular
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: colors[index],
                  borderRadius: BorderRadius.circular(50),
                ),
              ),

              // divider
              Container(
                width: 1,
                height: size.height * 0.1,
                color: timelineColor,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: dividerColor,
                    fontFamily: 'Prompt',
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: dividerColor,
                    fontFamily: 'Prompt',
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: dividerColor,
                    fontFamily: 'Prompt',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
