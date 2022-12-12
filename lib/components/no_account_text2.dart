import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/sign_in/sign_up_salon/sign_up_salon_screen.dart';
import '../size_config.dart';

class NoAccountText2 extends StatelessWidget {
  const NoAccountText2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Want to join to purple salons? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(
              context, SignUpSalonScreen.routeName),
          child: Text(
            "Join now",
            style: TextStyle(
              // decoration: TextDecoration.underline,
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}