import 'package:intl/intl.dart';

class ExitModel {
  String msg;
  String type;
  int classIds;
  int visitorId;
  int homeId;
  String cLass;
  int classId;
  String firstname;
  String lastname;
  String licensePlate;
  String idCord;
  String inviteDate;
  String qrGenId;
  int logId;
  String homeName;
  String homeNumber;
  int stampCount;
  String datetimeIn;

  createDT() {
    String date = datetimeIn.split("T")[0];
    String time = datetimeIn.split("T")[1].split(".")[0];
    DateTime dt = DateTime.parse(date + ' ' + time);
    return dt;
  }

  getDate() {
    DateTime dt = createDT();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dt);

    int year = int.parse(formattedDate.split("-")[0]);
    int mon = int.parse(formattedDate.split("-")[1]);
    int day = int.parse(formattedDate.split("-")[2]);

    return day.toString() +
        " " +
        mapMonEndToMonThai(mon) +
        " " +
        (year + 543).toString();
  }

  mapMonEndToMonThai(int m) {
    Map mon = {
      1: "มกราคม",
      2: "กุมภาพันธ์",
      3: "มีนาคม",
      4: "เมษายน",
      5: "พฤษภาคม",
      6: "มิถุนายน",
      7: "กรกฎาคม",
      8: "สิงหาคม",
      9: "กันยายน",
      10: "ตุลาคม",
      11: "พฤศจิกายน",
      12: "ธันวาคม",
    };

    return mon[m];
  }

  getTime() {
    DateTime dt = createDT();
    String formattedTime = DateFormat('HH:mm').format(dt);
    return formattedTime + ' น.';
  }

  getTimeout() {
    String formattedTime = DateFormat('HH:mm').format(DateTime.now());
    return formattedTime + ' น.';
  }

  ExitModel(
    this.msg,
    this.type,
    this.classIds,
    this.visitorId,
    this.homeId,
    this.cLass,
    this.classId,
    this.firstname,
    this.lastname,
    this.licensePlate,
    this.idCord,
    this.inviteDate,
    this.qrGenId,
    this.logId,
    this.homeName,
    this.homeNumber,
    this.stampCount,
    this.datetimeIn,
  );

  factory ExitModel.fromJson(dynamic json) {
    return ExitModel(
      json['msg'],
      json['data']['type'],
      json['data']['class_ids'],
      json['data']['visitor_id'],
      json['data']['home_id'],
      json['data']['class'],
      json['data']['class_id'],
      json['data']['firstname'],
      json['data']['lastname'],
      json['data']['license_plate'],
      json['data']['id_card'],
      json['data']['invite_date'],
      json['data']['qr_gen_id'],
      json['data']['log_id'],
      json['data']['home_name'],
      json['data']['home_number'],
      json['data']['stamp_count'],
      json['data']['datetime_in'],
    );
  }
}

// {
//   "msg": "resident not stamp",
//   "data": {
//     "type": "visitor",
//     "class_ids": 13,
//     "visitor_id": 13,
//     "home_id": 1,
//     "class": "visitor",
//     "class_id": 13,
//     "firstname": "นัฐพล",
//     "lastname": "นนทะศรี",
//     "license_plate": "12กกด",
//     "id_card": null,
//     "invite_date": "2021-09-29",
//     "qr_gen_id": "V84857175752071423783",
//     "create_datetime": "2021-07-11T04:35:58.982770",
//     "log_id": 22,
//     "datetime_in": "2021-10-07T13:46:07.913927",
//     "resident_stamp": null,
//     "resident_send_admin": null,
//     "resident_reason": null,
//     "admin_datetime": null,
//     "admin_approve": null,
//     "admin_reason": null,
//     "datetime_out": null,
//     "home_name": "บ้านสิรินธร",
//     "home_number": "1/1",
//     "stamp_count": 2,
//     "update_datetime": "2021-07-20T03:58:04.219919"
//   }
// }
