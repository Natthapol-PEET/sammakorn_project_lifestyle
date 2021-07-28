import 'package:flutter/material.dart';

class CardListTimeline extends StatelessWidget {
  const CardListTimeline({
    Key key,
    @required this.itemcard,
    @required this.index,
    @required this.isEnable,
    this.pass,
  }) : super(key: key);

  final List itemcard;
  final int index;
  final bool isEnable;
  final Function pass;

  @override
  Widget build(BuildContext context) {
    List colors = [
      Colors.green,
      Colors.orange,
      Colors.blue,
      Colors.yellow,
      Colors.yellow,
      Colors.yellow,
      Colors.yellow,
      Colors.yellow,
      Colors.green
    ];

    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 2,
                height: 45,
                color: Colors.white,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: colors[index],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(itemcard[index].icon, color: Colors.white),
              ),
              Container(
                width: 2,
                height: 45,
                color: Colors.white,
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onTap: isEnable ? pass : null,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isEnable ? Colors.blue.shade100 : Colors.white,
                  border: Border(top: BorderSide(width: 4, color: Colors.blue)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                    )
                  ],
                ),
                height: 90,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(itemcard[index].title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 3),
                      Text(itemcard[index].getDate(),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(itemcard[index].getTime(),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
