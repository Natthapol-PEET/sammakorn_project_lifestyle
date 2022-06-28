// IF isInvite is True

class ResidentModelCheckout {
  int residentId;
  String firstname;
  String lastname;
  String username;
  int homeId;
  String cardInfo;
  String homeName;
  String homeNumber;
  String licensePlate = "";

  ResidentModelCheckout(
    this.residentId,
    this.firstname,
    this.lastname,
    this.username,
    this.homeId,
    this.cardInfo,
    this.homeName,
    this.homeNumber,
  );

  factory ResidentModelCheckout.fromJson(dynamic json) {
    json = json['data'];
    return ResidentModelCheckout(
      json['resident_id'],
      json['firstname'],
      json['lastname'],
      json['username'],
      json['home_id'],
      json['card_info'],
      json['home_name'],
      json['home_number'],
    );
  }
}
