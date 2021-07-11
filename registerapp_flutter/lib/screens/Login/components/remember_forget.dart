import 'package:flutter/material.dart';
import '../../../constance.dart';

class RememberAndForget extends StatelessWidget {
  const RememberAndForget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              onChanged: (value) {},
              value: true,
            ),
            Text("Remember me", style: TextStyle(color: Colors.white)),
          ],
        ),
        Text("Forgot password",
            style: TextStyle(color: goldenSecondary)),
      ],
    );
  }
}
