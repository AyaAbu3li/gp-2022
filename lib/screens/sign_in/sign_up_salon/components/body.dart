import 'package:flutter/material.dart';
import 'package:purple/constants.dart';
import 'package:purple/size_config.dart';
import '../../../../components/default_button.dart';
import 'sign_up_salon_form.dart';

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
                SizedBox(height: SizeConfig.screenHeight * 0.01), // 1%
                Text("Register Salon Account", style: headingStyle),
                Text(
                  "Complete salon details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                SignUpSalonForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.1),

                // SizedBox(height: getProportionateScreenHeight(20)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}