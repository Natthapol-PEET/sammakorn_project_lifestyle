import 'package:flutter/material.dart';

class RegisterTitle extends StatelessWidget {
  const RegisterTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        'Register',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
