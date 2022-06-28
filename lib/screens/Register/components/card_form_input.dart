import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/rounded_button.dart';
import 'package:registerapp_flutter/components/rounded_input_field.dart';
import 'package:registerapp_flutter/components/rounded_password_field.dart';
import 'package:registerapp_flutter/screens/Login/components/welcome_text.dart';
import '../../../constance.dart';
import 'hello_there.dart';

class CardFormInput extends StatelessWidget {
  const CardFormInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: size.width,
        height: size.height * 0.85,
        decoration: BoxDecoration(
          color: greenPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.05),
            WelcomeText(),
            HelloThere(),
            SizedBox(height: size.height * 0.05),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              textHiht: "Password",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              textHiht: "Confirm Password",
              onChanged: (value) {},
            ),
            Row(
              children: [
                SizedBox(width: size.height * 0.03),
                Checkbox(
                  checkColor: Colors.white,
                  onChanged: (value) {},
                  value: true,
                ),
                Text("I agree to the ", style: TextStyle(color: Colors.white)),
                Text("Terms & Conditions",
                    style: TextStyle(
                      color: goldenSecondary,
                      decoration: TextDecoration.underline,
                    )),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "Register",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}
