import 'package:flutter/material.dart';
import 'package:purple/screens/sign_in/sign_up/sign_up_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(18)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(
              context, SignUpScreen.routeName),
          child: Text(
            "Sign Up",
            style: TextStyle(
              // decoration: TextDecoration.underline,
                fontSize: getProportionateScreenWidth(18),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}