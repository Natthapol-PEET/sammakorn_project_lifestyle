import 'package:flutter/material.dart';
import '../../../constance.dart';

class BottomNavBar extends StatelessWidget {
  final String titleButton;
  final IconData iconButton;
  final Function pass;

  const BottomNavBar({
    Key key,
    this.pass,
    this.titleButton,
    this.iconButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(greenPrimary),
        ),
        onPressed: pass,
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Icon(
                iconButton,
                color: Colors.white,
              ),
              Text(
                titleButton,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: greenPrimary,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.arrow_back_ios, color: Colors.white),
      //       title: Text(
      //         'Back',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.approval, color: Colors.white),
      //       title: Text(
      //         'Stamp',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //   ],
      // ),