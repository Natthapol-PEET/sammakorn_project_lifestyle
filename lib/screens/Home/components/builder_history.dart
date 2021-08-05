import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constance.dart';

class BoxShowListHistory extends StatelessWidget {
  final List lists;
  final Color color;
  final String select;

  BoxShowListHistory({
    Key key,
    @required this.lists,
    @required this.color,
    this.select,
  }) : super(key: key);

  String dateStr = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final date = DateFormat('dd-MMMM-yyyy').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: size.height * 0.72,
        width: size.width,
        decoration: BoxDecoration(
          color: darkgreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuilderList(context, lists, select),
            ],
          ),
        ),
      ),
    );
  }

  ListView BuilderList(context, lists, select) {
    final Size size = MediaQuery.of(context).size;

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: lists.length,
      itemBuilder: (context, index) {
        String date = lists[index]['datetime_out'].split('T')[0];
        String time = lists[index]['datetime_out'].split('T')[1];
        DateTime dt = DateTime.parse(date + ' ' + time);
        final dateFormat = DateFormat('dd-MMMM-yyyy').format(dt);

        if (dateFormat != dateStr) {
          dateStr = dateFormat;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateTitle(dateFormat),
                ListItem(lists, index, select, context, size),
              ],
            ),
          );
        } else {
          return GestureDetector(
            onTap: () {
              lists[index]['select'] = select;
              Navigator.pushNamed(context, '/show_detail',
                  arguments: lists[index]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                height: 65,
                width: size.width,
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
                        color: color,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 10,
                      child: Text("Status: ${select}",
                          style: TextStyle(color: color)),
                    ),
                    Positioned(
                      top: 10,
                      left: 30,
                      child: Text(
                        lists[index]['license_plate'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 30,
                      child: Text(
                        lists[index]['fullname'],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } // else
      },
    );
  }

  Padding DateTitle(String dateFormat) {
    return Padding(
      padding: const EdgeInsets.only(left: 21, top: 26, bottom: 15),
      child: Text('Date ${dateFormat}',
          style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  GestureDetector ListItem(
      lists, int index, select, BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        lists[index]['select'] = select;
        Navigator.pushNamed(context, '/show_detail', arguments: lists[index]);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          height: 65,
          width: size.width,
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
                  color: color,
                ),
              ),
              Positioned(
                top: 5,
                right: 10,
                child:
                    Text("Status: ${select}", style: TextStyle(color: color)),
              ),
              Positioned(
                top: 10,
                left: 30,
                child: Text(
                  lists[index]['license_plate'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 30,
                child: Text(
                  lists[index]['fullname'],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
