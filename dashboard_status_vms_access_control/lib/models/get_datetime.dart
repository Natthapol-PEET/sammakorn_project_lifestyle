import 'package:intl/intl.dart';

class GetDateTime {
  DateTime now = DateTime.now();

  // String _24H = DateFormat('Hm').format(now);
  // var date = DateFormat('jm').format(now).split(" ");
  // int h = int.parse(_24H.split(":")[0]);
  // int m = int.parse(_24H.split(":")[1]);

  getNow() => DateTime.now();

  get24H() => DateFormat('Hm').format(getNow());

  getH() => int.parse(get24H().split(":")[0]);

  getm() => int.parse(get24H().split(":")[1]);
}
