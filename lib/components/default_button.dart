import 'package:flutter/material.dart';
import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key = const Key("any_key"),
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child:
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          press();
          // Navigator.pushNamed(context, SignInScreen.routeName);
        },
        child: Text(text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,),

        ),
      ),
    );
  }
}