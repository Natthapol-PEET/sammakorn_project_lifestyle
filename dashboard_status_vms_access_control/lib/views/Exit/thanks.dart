import 'package:dashboard_status_vms_access_control/views/Components/backgroud.dart';
import 'package:flutter/material.dart';

class ThanksScreen extends StatelessWidget {
  const ThanksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Backgroud(
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ArtaniLogoNotName.png',
                    scale: 1,
                  ),
                  SizedBox(height: 50),
                  Text(
                    "THANK YOU FOR VISITING",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 96,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "ขอให้เดินทางโดยสวัสดิภาพ",
                    style: TextStyle(
                      fontFamily: "Prompt",
                      color: Colors.white,
                      fontSize: 72,
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                height: size.height * 0.15,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bottom.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
