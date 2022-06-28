import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? textHiht;
  final TextEditingController? controller;
  final bool hidePassword;
  final Function()? press;

  const RoundedPasswordField({
    Key? key,
    this.onChanged,
    @required this.textHiht,
    this.controller,
    this.hidePassword = true,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textHiht??'',
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 16,
              color: Color(0xFFB8B7B2),
            ),
          ),
          Center(
            child: Container(
              width: size.width,
              child: TextFieldContainer(
                child: TextField(
                  controller: controller,
                  obscureText: hidePassword,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: textHiht,
                    suffixIcon: InkWell(
                      onTap: press,
                      child: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
