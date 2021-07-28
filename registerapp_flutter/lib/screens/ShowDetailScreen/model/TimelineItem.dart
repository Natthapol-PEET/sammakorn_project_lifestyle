import 'package:flutter/cupertino.dart';

class TimeLineItem {
  String title;
  String description;
  IconData icon;
  String date;
  String time;

  getDate() => this.date = "วันที่ " + description.split("T")[0];
  getTime() => this.time = "เวลา " +
      description.split("T")[1].split(":")[0] +
      '.' +
      description.split("T")[1].split(":")[1] + ' น.';

  TimeLineItem(this.title, this.description, this.icon);
}
