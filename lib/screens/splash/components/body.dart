import 'package:flutter/material.dart';
import 'package:purple/constants.dart';
import 'package:purple/size_config.dart';

import 'package:purple/screens/sign_in/sign_in_screen.dart';

import '../../sign_in/sign_up/sign_up_screen.dart';
import '../components/splash_content.dart';
import '../../../components/default_button.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text":
      "Welcome to Purple app! \nWhere all salons here",
      "image":
      "assets/images/splash_1.png"
    },
    {
      "text":
      "We help people connect with salons \naround Palestine",
      "image":
      "assets/images/splash_2.png"
    },
    {
      "text":
      "We show the easy way to \nbook an appointment",
      "image":
      "assets/images/splash_3.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"] ?? '',
                  text: splashData[index]['text'] ?? '',
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                            (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 2),
                    DefaultButton(
                      text: "Sign In",
                      press: () {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                SizedBox(
                  width: double.infinity,
                  height: getProportionateScreenHeight(56),
                  child:
                    TextButton(
                      style: TextButton.styleFrom(
                        // primary: Colors.purpleAccent, // foreground
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                        // Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                      child: Text("Sign Up",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          color: Colors.white,),

                      ),
                    ),
                ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}