import 'package:flutter/material.dart';
import '../../../constance.dart';

class CardListItem extends StatelessWidget {
  final String imagePath;
  final String title;

  const CardListItem({
    Key key,
    @required this.imagePath,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width * 0.4,
              height: size.height * 0.04,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.black45,
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: goldenSecondary,
                    fontWeight: FontWeight.w400,
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
