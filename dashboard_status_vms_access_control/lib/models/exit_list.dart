class ExitList {
  int statusPage;
  String fullname;
  String licensePlate;
  String homeNumber;
  String entryTime;
  String timeOfDeparture;
  String statusUser;
  var data;

  ExitList(this.statusPage, this.fullname, this.licensePlate, this.homeNumber,
      this.entryTime, this.timeOfDeparture, this.statusUser, this.data);

  factory ExitList.fromJson(dynamic json) {
    return ExitList(
      json['statusPage'] as int,
      json['fullname'] as String,
      json['licensePlate'] as String,
      json['homeNumber'] as String,
      json['entryTime'] as String,
      json['timeOfDeparture'] as String,
      json['statusUser'] as String,
      json['data'],
    );
  }
}
