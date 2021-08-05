import 'package:flutter/material.dart';

import '../../../constance.dart';

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
      inviteColor,
      comingColor,
      infrontColor,
      villColor,
      Colors.yellow,
      Colors.yellow,
      Colors.yellow,
      Colors.yellow,
      Colors.green
    ];

    Size size = MediaQuery.of(context).size;

    // print(itemcard[index].getDate());
    // print(itemcard[index].getTime());
    // print(itemcard[index].title);
    // print(itemcard[index].icon);
    // print('');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        child: Row(
          children: [
            Text(itemcard[index].getTime(),
                style: TextStyle(color: goldenSecondary)),
            Column(
              children: [
                Container(
                  width: 2,
                  height: 45,
                  color: timelineColor,
                ),
                Container(
                  width: 15,
                  height: 15,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: colors[index],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  // child: Icon(itemcard[index].icon, color: Colors.white),
                ),
                Container(
                  width: 2,
                  height: 45,
                  color: timelineColor,
                ),
              ],
            ),
            Expanded(
              child: GestureDetector(
                onTap: isEnable ? pass : null,
                child: Container(
                  height: 70,
                  width: size.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                          color: colors[index],
                        ),
                      ),
                      // Positioned(
                      //   top: 5,
                      //   left: 10,
                      //   child: Text(
                      //     "Status: ",
                      //     // style: TextStyle(color: color),
                      //   ),
                      // ),
                      Positioned(
                        top: 12,
                        left: 20,
                        child: Text(
                          itemcard[index].title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 20,
                        child: Text(
                          itemcard[index].getDate(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Expanded(
            //   child: GestureDetector(
            //     onTap: isEnable ? pass : null,
            //     child: Container(
            //       margin: EdgeInsets.all(10),
            //       decoration: BoxDecoration(
            //         color: isEnable ? Colors.blue.shade100 : Colors.white,
            //         border: Border(top: BorderSide(width: 4, color: Colors.blue)),
            //         boxShadow: [
            //           BoxShadow(
            //             blurRadius: 10,
            //             color: Colors.black26,
            //           )
            //         ],
            //       ),
            //       height: 90,
            //       child: Padding(
            //         padding: EdgeInsets.all(8),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(itemcard[index].title,
            //                 style: TextStyle(
            //                     fontSize: 16, fontWeight: FontWeight.bold)),
            //             SizedBox(height: 3),
            //             Text(itemcard[index].getDate(),
            //                 style: TextStyle(
            //                     fontSize: 14, fontWeight: FontWeight.bold)),
            //             Text(itemcard[index].getTime(),
            //                 style: TextStyle(
            //                     fontSize: 14, fontWeight: FontWeight.bold))
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
