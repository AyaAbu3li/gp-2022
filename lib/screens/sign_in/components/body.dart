import 'package:flutter/material.dart';
import 'package:purple/components/no_account_text.dart';
import '../../../components/default_button.dart';
// import '../../../components/form_error.dart';
import '../../../size_config.dart';
import '../sign_in_screen.dart';
import 'sign_form.dart';
import 'profile_pic.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                ProfilePic(),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "Sign in with your email and password ",
                  style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                SignForm(),
                SizedBox(height: getProportionateScreenHeight(30)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}