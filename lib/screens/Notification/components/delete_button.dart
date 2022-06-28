import 'package:flutter/material.dart';
import '../../../constance.dart';

class DeleteButton extends StatelessWidget {
  final Function()? pass;

  const DeleteButton({
    Key? key,
    required this.pass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
      child: ButtonTheme(
        minWidth: size.width * 0.6,
        child: RaisedButton(
          color: goldenSecondary,
          child: Text("Delete", style: TextStyle(color: Colors.white)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onPressed: pass,
        ),
      ),
    );
  }
}
