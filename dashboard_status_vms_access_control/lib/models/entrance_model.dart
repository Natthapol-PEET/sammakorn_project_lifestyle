// IF isInvite is True

class EntranceModel {
  bool isInvite;
  String type;
  int classIds;
  int visitorId;
  int homeId;
  String cLass;
  String firstname;
  String lastname;
  String licensePlate;
  String idCard;
  String inviteDate;
  String qrGenId;
  String homeName;
  String homeNumber;
  int stampCount;

  EntranceModel(
    this.isInvite,
    this.type,
    this.classIds,
    this.visitorId,
    this.homeId,
    this.cLass,
    this.firstname,
    this.lastname,
    this.licensePlate,
    this.idCard,
    this.inviteDate,
    this.qrGenId,
    this.homeName,
    this.homeNumber,
    this.stampCount,
  );

  factory EntranceModel.fromJson(dynamic json) {
    return EntranceModel(
      json['isInvite'],
      json['data']['type'],
      json['data']['class_ids'],
      json['data']['visitor_id'],
      json['data']['home_id'],
      json['data']['class'],
      json['data']['firstname'],
      json['data']['lastname'],
      json['data']['license_plate'],
      json['data']['id_card'],
      json['data']['invite_date'],
      json['data']['qr_gen_id'],
      json['data']['home_name'],
      json['data']['home_number'],
      json['data']['stamp_count'],
    );
  }
}
