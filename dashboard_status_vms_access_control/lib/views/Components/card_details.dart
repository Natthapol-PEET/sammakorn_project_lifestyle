
import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/models/data_in.dart';
import 'package:dashboard_status_vms_access_control/views/Components/text_list_card.dart';
import 'package:flutter/material.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({
    Key key,
    @required this.data,
  }) : super(key: key);

  // final DataList data;
  final DataIn data;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: size.height * 0.18,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextListCard(text: "Name: ${data.fullname}"),
                  Text(
                    "Time : ${data.time}",
                    style: TextStyle(
                      fontSize: 26,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
              TextListCard(text: "License Plate: ${data.licensePlate}"),
              TextListCard(text: "Home Number: ${data.homeNumber}"),
            ],
          ),
        ),
      ),
    );
  }
}
