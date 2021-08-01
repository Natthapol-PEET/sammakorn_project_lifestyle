import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constance.dart';

class BoxShowList extends StatelessWidget {
  final List lists, resident_send_admin, pms_show, checkout;
  final Color color;
  final String select;
  final String selectRSA, selectPMS, selectCO;

  BoxShowList({
    Key key,
    @required this.lists,
    @required this.color,
    this.select,
    this.resident_send_admin,
    this.pms_show,
    this.checkout,
    this.selectRSA,
    this.selectPMS,
    this.selectCO,
  }) : super(key: key);

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
              Padding(
                padding: const EdgeInsets.only(left: 21, top: 26, bottom: 26),
                child: Text('Date ${date}',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              BuilderList(context, lists, select),
              if (select == "Resident stamp") ...[
                BuilderList(context, resident_send_admin, selectRSA),
                BuilderList(context, pms_show, selectPMS),
                BuilderList(context, checkout, selectCO)
              ],
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
                    child: Text(
                        // select == "Resident stamp" ||
                        //         select == "Wait Admin" ||
                        //         select == "Admin done"
                        //     ? "Status: Stamp"
                        //     : "Status: ${lists[index]['status']}",
                        select == "coming_walk"
                            ? "Status: ${lists[index]['type']}"
                            : "Status: ${select}",
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
      },
    );
  }
}
