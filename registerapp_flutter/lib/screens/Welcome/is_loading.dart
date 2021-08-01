import 'package:flutter/material.dart';
import 'components/backgroud.dart';

class IsLoadding extends StatelessWidget {
  const IsLoadding({
    Key key,
    @required this.isLogin,
  }) : super(key: key);

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Backgroud(
      isLogin: isLogin,
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: size.height * 0.03),
            Text("Loading",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
