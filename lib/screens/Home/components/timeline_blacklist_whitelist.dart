import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Home/components/title_tab_bar.dart';

import '../../../constance.dart';

class ListItemBlacklistWhitelist extends StatelessWidget {
  final List lists;
  final String select;

  const ListItemBlacklistWhitelist({
    Key key,
    @required this.lists,
    @required this.select,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TitleTabBar(),
            Container(
              height: size.height * 0.655,
              color: darkgreen,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TabBarView(
                  children: [
                    BuilderList(context, lists, 'White List'),
                    BuilderList(context, lists, 'Blacklist List'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView BuilderList(context, lists, type) {
    final Size size = MediaQuery.of(context).size;

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: lists.length,
      itemBuilder: (context, index) {
        // String date = lists[index]['invite'].split('T')[0];
        // String time = lists[index]['invite'].split('T')[1];
        // DateTime dt = DateTime.parse(date + ' ' + time);
        // final dateFormat = DateFormat('dd-MMMM-yyyy').format(dt);

        if (lists[index]['type'] == type) {
          return GestureDetector(
            onTap: () {
              lists[index]['select'] = "blacklist and whitelist";
              Navigator.pushNamed(context, '/show_detail',
                  arguments: lists[index]);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        color: lists[index]['admin_approve'] == null ||
                                lists[index]['resident_remove_datetime'] != null
                            ? goldenSecondary
                            : lists[index]['admin_approve']
                                ? approveColor
                                : disapproveColor,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 10,
                      child: Text(
                          "Status: ${lists[index]['admin_approve'] == null || lists[index]['resident_remove_datetime'] != null ? 'Wait approve' : lists[index]['admin_approve'] == false ? 'Disapprove' : 'Approve'}",
                          style: TextStyle(
                            color: lists[index]['admin_approve'] == null ||
                                    lists[index]['resident_remove_datetime'] !=
                                        null
                                ? goldenSecondary
                                : lists[index]['admin_approve']
                                    ? approveColor
                                    : disapproveColor,
                          )),
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
        } else {
          return Container();
        }
      },
    );
  }
}
