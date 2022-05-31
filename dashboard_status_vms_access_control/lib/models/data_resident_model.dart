// IF isInvite is True

class ResidentModel {
  bool isInvite;
  String type;
  int classIds;
  int visitorId;
  int homeId;
  String cLass;
  String fullname;
  String licensePlate;
  String qrGenId;
  String homeName;
  String homeNumber;

  ResidentModel(
    this.isInvite,
    this.type,
    this.classIds,
    this.visitorId,
    this.homeId,
    this.cLass,
    this.fullname,
    this.licensePlate,
    this.qrGenId,
    this.homeName,
    this.homeNumber,
  );

  factory ResidentModel.fromJson(dynamic json) {
    return ResidentModel(
      json['isInvite'],
      'resident', // json['data']['type'],
      json['data']['class_ids'],
      json['data']['resident_id'],
      json['data']['home_id'],
      'resident', // json['data']['class'],
      json['data']['firstname'] + "  " + json['data']['lastname'],
      '', // json['data']['license_plate'],
      json['data']['card_info'],
      json['data']['home_name'],
      json['data']['home_number'],
    );
  }
}
