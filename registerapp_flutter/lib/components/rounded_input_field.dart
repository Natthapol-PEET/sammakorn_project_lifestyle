import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: size.width,
        child: TextFieldContainer(
          child: TextField(
            onChanged: onChanged,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                icon,
                color: Colors.black,
              ),
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
