// import 'package:flutter_gpiod/flutter_gpiod.dart';
import 'package:dashboard_status_vms_access_control/config/config.dart';
import 'package:http/http.dart' as http;

// openGateBar() => http.get(Uri.parse(openGate));
// closeGateBar() => http.get(Uri.parse(closeGate));

// initRelay(int pin) {
//   openGateBar();
//   Future.delayed(const Duration(seconds: relayDelay), () => closeGateBar());
// }

// Future manageRelay(int pin) async {
//   openGateBar();
//   Future.delayed(const Duration(seconds: relayDelay), () => closeGateBar());
// }

// initRelay(int pin) => ledState(pin, true);

// Future manageRelay(int pin) async {
//   ledState(pin, false);
//   // Future.delayed(const Duration(seconds: 5), () => ledState(pin, true));
// }

// void ledState(int pin, bool state) {
//   // Retrieve the list of GPIO chips.
//   final chips = FlutterGpiod.instance.chips;

//   // Retrieve the line with index 24 of the first chip.
//   // This is BCM pin 24 for the Raspberry Pi.
//   final chip = chips.singleWhere(
//     (chip) => chip.label == 'pinctrl-bcm2711',
//     orElse: () => chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835'),
//   );

//   final line2 = chip.lines[pin];

//   // Request BCM 24 as output.
//   line2.requestOutput(consumer: "flutter_gpiod test", initialValue: false);
//   line2.setValue(state);
//   line2.release();
// }



// initRelay(int pin) => ledState(pin, true);

// Future manageRelay(int pin) async {
//   ledState(pin, false);
//   // Future.delayed(const Duration(seconds: 5), () => ledState(pin, true));
// }

// ledState(int pin, bool state) => print("${pin} => ${state}");
