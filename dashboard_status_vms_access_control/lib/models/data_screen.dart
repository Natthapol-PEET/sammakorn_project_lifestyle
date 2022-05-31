import 'data_in.dart';

class DataScreen {
  int status;
  String fullname;
  String license_plate;
  String home_number;
  var data;

  DataScreen(this.status, this.fullname, this.license_plate, this.home_number,
      this.data);

  factory DataScreen.fromJson(dynamic json) {
    return DataScreen(
      json['status'] as int,
      json['fullname'] as String,
      json['license_plate'] as String,
      json['home_number'] as String,
      // DataList.fromJson(json['data']) as List,
      json['data'],
    );
  }

  factory DataScreen.fromDataIn(DataIn map, List data) {
    return DataScreen(
      1,
      map.fullname,
      map.licensePlate,
      map.homeNumber,
      // DataList.fromJson(json['data']) as List,
      data,
    );
  }

  // @override
  // String toString() {
  //   return '{ ${this.license_plate}, ${this.data[0]['fullname']} }';
  // }
}
