import 'package:flutter/material.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class alert extends StatelessWidget {
const alert({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) => Scaffold(
appBar: AppBar(
title: const Text('Alers'),
),
body: SafeArea(
child: SizedBox(
width: double.infinity,
child: Padding(
padding:
EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
child: SingleChildScrollView(
child: Column(
children: [
  Row( children: [
    Image.asset('assets/images/log.png',width: 150,height: 160,),
    // SizedBox( width: 5.0),
   Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add image for the alert",
              style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.02),

            TextButton(
      style: TextButton.styleFrom(
        // primary: Colors.purpleAccent, // foreground
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   //     Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => const editWhoAreWe(),
        // ));
        // Navigator.pushNamed(context, SignUpScreen.routeName);
        // Navigator.pushNamed(context, SignInScreen.routeName);
      },

      child: Text("Add Image",
        style: TextStyle(
          fontSize: getProportionateScreenWidth(15),
          color: Colors.white,),

      ),
    ),
]
      ),
   ),






  ]
  ),

  SizedBox(height: SizeConfig.screenHeight * 0.01),
  const Divider(color: Colors.black54),
  SizedBox(height: SizeConfig.screenHeight * 0.01),

  Row( children: [

  Text(
    "Alert title",
    style: TextStyle(
      color: Colors.black,
      fontSize: getProportionateScreenWidth(18),
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.left,
  ),
],
  ),
  TextFormField(
    // initialValue: "I am smart",
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
    ),
    minLines: 1,
    maxLines: null,
  ),
  SizedBox(height: SizeConfig.screenHeight * 0.02),
  Row( children: [

  Text(
    "Alert details",
    style: TextStyle(
      color: Colors.black,
      fontSize: getProportionateScreenWidth(18),
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.left,
  ),
  ],
  ),
  TextFormField(
    // initialValue: "I am smart",
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
    ),
    minLines: 3,
    maxLines: null,
  ),


  SizedBox(height: SizeConfig.screenHeight * 0.03),
  DefaultButton(
    text: "Send",
    press: () {
      // if (_formKey.currentState!.validate()) {
        // if (_formKey.currentState.validate()) {
        // Do what you want to do
      // }
    },
  ),

  SizedBox(height: SizeConfig.screenHeight * 0.04),

]
),
),
),
),
),
);
}