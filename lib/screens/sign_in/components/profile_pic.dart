import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 140,
      child: Stack(
        clipBehavior: Clip.none, fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/log.png"),
            backgroundColor: Colors.white,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 80,
              width: 100,
            ),
          )
        ],
      ),
    );
  }
}