import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.controller,
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
            hintText??'',
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
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 30),
    //   child: Container(
    //     width: size.width,
    //     child: TextFieldContainer(
    //       child: TextField(
    //         controller: controller,
    //         onChanged: onChanged,
    //         cursorColor: Colors.black,
    //         decoration: InputDecoration(
    //           icon: Icon(
    //             icon,
    //             color: Colors.black,
    //           ),
    //           hintText: hintText,
    //           border: InputBorder.none,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
