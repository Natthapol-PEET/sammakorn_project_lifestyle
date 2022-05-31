/* 
  Model Comming In
 */

import 'package:intl/intl.dart';

class DataIn {
  String fullname;
  String licensePlate;
  String homeNumber;
  int homeId;
  String time;
  String type;

  DataIn(this.fullname, this.licensePlate, this.homeNumber, this.homeId,
      this.time, this.type);

  factory DataIn.fromJson(dynamic json) {
    final String fullname =
        json['data']['firstname'] + '  ' + json['data']['lastname'];

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat.jm();
    // final DateFormat formatter = DateFormat('Hm ');
    final String formatted = formatter.format(now);

    return DataIn(
      fullname,
      json['data']['license_plate'] as String,
      json['data']['home_number'] as String,
      json['data']['home_id'] as int,
      formatted,
      json['data']['type'] as String,
    );
  }
}
