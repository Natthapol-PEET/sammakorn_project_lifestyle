class PackData {
  String? date;
  String? time;
  String? text;

  PackData({this.date, this.time, this.text});

  factory PackData.fromJson(dynamic json) {
    return PackData(
      date: json['date'],
      time: json['time'],
      text: json['text'],
    );
  }
}
