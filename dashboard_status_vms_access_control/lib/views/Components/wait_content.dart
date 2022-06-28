import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WaitContent extends StatelessWidget {
  const WaitContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SpinKitHourGlass(
          size: 100,
          color: Colors.white,
        ),
        Positioned(
          bottom: 80,
          child: Text(
            "waiting ...",
            style: TextStyle(
              fontSize: 48,
              color: Colors.white,
            ),
          ),
        ),
      ],
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Image.asset(
      //       "images/delivery.gif",
      //       fit: BoxFit.cover,
      //     ),
      //     Text(
      //       "Waiting ...",
      //       style: TextStyle(
      //         fontSize: 72,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
