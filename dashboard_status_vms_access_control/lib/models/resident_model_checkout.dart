// IF isInvite is True

class ResidentModelCheckout {
  int residentId;
  String fullname;
  String username;
  int homeId;
  String cardInfo;
  String homeName;
  String homeNumber;
  String licensePlate = "";

  ResidentModelCheckout(
    this.residentId,
    this.fullname,
    this.username,
    this.homeId,
    this.cardInfo,
    this.homeName,
    this.homeNumber,
  );

  factory ResidentModelCheckout.fromJson(dynamic json) {
    json = json['data'];
    String fullname = json['firstname'] + ' ' + json['lastname'];
    return ResidentModelCheckout(
      json['resident_id'],
      fullname,
      json['username'],
      json['home_id'],
      json['card_info'],
      json['home_name'],
      json['home_number'],
    );
  }
}
