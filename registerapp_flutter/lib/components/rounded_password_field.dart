import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String textHiht;
  
  const RoundedPasswordField({
    Key key,
    this.onChanged, 
    @required this.textHiht,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: size.width,
        child: TextFieldContainer(
          child: TextField(
            obscureText: true,
            onChanged: onChanged,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: textHiht,
              icon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              suffixIcon: Icon(
                Icons.visibility,
                color: Colors.black,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
