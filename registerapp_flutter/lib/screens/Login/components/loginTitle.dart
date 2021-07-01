import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
