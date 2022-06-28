class WhitelistModel {
  int? whitelistId;
  int? homeId;
  String? addBy;
  int? addById;
  String? firstname;
  String? lastname;
  String? fullname;
  String? licensePlate;
  String? qrGenId;
  String? idCard;
  String? email;
  DateTime? whitelistCreateDT;
  int? logId;
  String? fromDB;
  int? fromDBId;
  DateTime? inviteDate;
  DateTime? datetimeIn;
  DateTime? residentStamp;
  DateTime? datetimeOut;
  DateTime? historyCreateDT;

  WhitelistModel({
    this.whitelistId,
    this.homeId,
    this.addBy,
    this.addById,
    this.firstname,
    this.lastname,
    this.fullname,
    this.licensePlate,
    this.qrGenId,
    this.idCard,
    this.email,
    this.whitelistCreateDT,
    this.logId,
    this.fromDB,
    this.fromDBId,
    this.inviteDate,
    this.datetimeIn,
    this.residentStamp,
    this.datetimeOut,
    this.historyCreateDT,
  });

  factory WhitelistModel.fromJson(Map<String, dynamic> json) {
    String? fullname = json['firstname'] == null
        ? null
        : json['firstname'] + ' ' + json['lastname'];

    return WhitelistModel(
      whitelistId: json['whitelist_id'],
      homeId: json['home_id'],
      addBy: json['addby'],
      addById: json['addby_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      fullname: fullname,
      licensePlate: json['license_plate'] == null || json['license_plate'] == ''
          ? null
          : json['license_plate'],
      qrGenId: json['qr_gen_id'],
      idCard: json['id_card'],
      email: json['email'],
      whitelistCreateDT: DateTime.parse(json['whitelist_create_datetime']),
      logId: json['log_id'],
      fromDB: json['class'],
      fromDBId: json['class_id'],
      inviteDate: DateTime.parse(json['datetime_in'].toString()),
      datetimeIn: DateTime.parse(json['datetime_in'].toString()),
      residentStamp: DateTime.tryParse(json['resident_stamp'].toString()),
      datetimeOut: DateTime.tryParse(json['datetime_out'].toString()),
      historyCreateDT: DateTime.parse(json['create_datetime']),
    );
  }
}
