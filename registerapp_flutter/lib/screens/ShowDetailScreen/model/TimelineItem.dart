import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TimeLineItem {
  String title;
  String description;
  String date;
  String time;

  // final df = DateFormat('dd-MM-yyyy hh:mm a');
  final df = DateFormat('dd-MMMM-yyyy');
  final tf = DateFormat('hh:mm a');

  // DateTime dt = DateTime.parse('2020-01-02 03:04:05');

  // 'resume'.replaceAll(RegExp(r'e'), 'é'); // 'résumé'

  getDate() => this.date =
      'Date : ' + df.format(DateTime.parse(description.split("T")[0]));
  // getTime() => this.time = tf.format(DateTime.parse(description.split("T")[1]));
  getTime() => this.time =
      tf.format(DateTime.parse(description.replaceAll(RegExp(r'T'), ' ')));
  // getTime() => this.time = "เวลา " +
  //     description.split("T")[1].split(":")[0] +
  //     '.' +
  //     description.split("T")[1].split(":")[1] + ' น.';

  TimeLineItem(this.title, this.description);
}
