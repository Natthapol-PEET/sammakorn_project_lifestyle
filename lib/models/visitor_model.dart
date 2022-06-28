class VisitorModel {
  int? visitorId;
  int? homeId;
  String? addBy;
  int? addById;
  String? firstname;
  String? lastname;
  String? fullname;
  String? licensePlate;
  String? idCard;
  DateTime? inviteDate;
  String? qrGenId;
  DateTime? visitorCreateDT;
  int? logId;
  String? fromDB;
  int? fromDBId;
  DateTime? datetimeIn;
  DateTime? residentStamp;
  DateTime? datetimeOut;
  DateTime? historyCreateDT;

  VisitorModel({
    this.visitorId,
    this.homeId,
    this.addBy,
    this.addById,
    this.firstname,
    this.lastname,
    this.fullname,
    this.licensePlate,
    this.idCard,
    this.inviteDate,
    this.qrGenId,
    this.visitorCreateDT,
    this.logId,
    this.fromDB,
    this.fromDBId,
    this.datetimeIn,
    this.residentStamp,
    this.datetimeOut,
    this.historyCreateDT,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    String invite =
        "${json['invite_date']}T${json['visitor_create_datetime'].split('T')[1]}";

    String? fullname = json['firstname'] == null
        ? null
        : json['firstname'] + ' ' + json['lastname'];

    return VisitorModel(
      visitorId: json['visitor_id'],
      homeId: json['home_id'],
      addBy: json['addby'],
      addById: json['addby_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      fullname: fullname,
      licensePlate: json['license_plate'] == null || json['license_plate'] == ''
          ? null
          : json['license_plate'],
      idCard: json['id_card'],
      inviteDate: DateTime.parse(invite),
      qrGenId: json['qr_gen_id'],
      visitorCreateDT: DateTime.parse(json['visitor_create_datetime']),
      logId: json['log_id'],
      fromDB: json['class'],
      fromDBId: json['class_id'],
      datetimeIn: DateTime.tryParse(json['datetime_in'].toString()),
      residentStamp: DateTime.tryParse(json['resident_stamp'].toString()),
      datetimeOut: DateTime.tryParse(json['datetime_out'].toString()),
      historyCreateDT: DateTime.tryParse(json['create_datetime'].toString()),
    );
  }
}
