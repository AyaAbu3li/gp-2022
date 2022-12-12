import 'package:flutter/material.dart';
import 'package:purple/constants.dart';
import 'package:purple/size_config.dart';
import '../../../../components/default_button.dart';
import 'package:purple/components/no_account_text2.dart';

import 'sign_up_form.dart';

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
                SizedBox(height: SizeConfig.screenHeight * 0.001), // 1%
                Text("Register Account", style: headingStyle),
                Text(
                  "Complete your details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                // SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText2(),
                SizedBox(height: getProportionateScreenHeight(40)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}