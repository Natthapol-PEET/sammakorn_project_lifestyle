import 'package:flutter/cupertino.dart';

class DisplayLogo extends StatelessWidget {
  const DisplayLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 50,
      child: Image.asset('assets/images/logo.png', scale: 0.7),
    );
  }
}
