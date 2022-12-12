import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:purple/constants.dart';
import '../../../Model/Whoarewe.dart';
import '../../../size_config.dart';
import '../admin_screen.dart';
import 'edit_who_are_we.dart';
import 'package:http/http.dart' as http;

class whoAreWe extends StatefulWidget {
const whoAreWe({Key? key}) : super(key: key);
_whoAreWeState createState() => _whoAreWeState();
}

class _whoAreWeState extends State<whoAreWe> {
  bool circular = true;
  Whoarewe whoarewe = Whoarewe('','','','','','');
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData() async {
    var res = await http.get(Uri.parse("http://"+ip+":3000/whoAreWe/63875089e605030b4d2f2476"),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    setState(() {
      var decoded = json.decode(res.body);
      whoarewe.name = decoded['name'];
      whoarewe.email = decoded['email'];
      whoarewe.picture = decoded['picture'];
      whoarewe.phone = decoded['phone'].toString();
      whoarewe.whoAreWe = decoded['whoAreWe'];
      whoarewe.WhatSetsUsApart = decoded['WhatSetsUsApart'];
      circular = false;

    });
  }

@override
Widget build(BuildContext context) => Scaffold(
  drawer: NavigationDrawer(),
appBar: AppBar(
title: const Text('Who Are We'),
),
  body: circular
      ? Center(child: CircularProgressIndicator())
      : SafeArea(
child: SizedBox(
width: double.infinity,
  child: Padding(
    padding:
    EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
    child: SingleChildScrollView(
      child: Column(
        children: [
      Image.asset(whoarewe.picture),
          Text(
            whoarewe.name,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(36),
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
      SizedBox(
        width: getProportionateScreenWidth(200),
        height: getProportionateScreenHeight(50),
        child:
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const editWhoAreWe(),
              ));
            },
            child: Text("Edit",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: Colors.white,),
            ),
          ),
      ),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          const Divider(color: Colors.black54),
          SizedBox(height: SizeConfig.screenHeight * 0.01),

          Text(
            "Who are we?",
            style: TextStyle(
              color: Colors.black,
              fontSize: getProportionateScreenWidth(22),
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            whoarewe.whoAreWe,
            style: TextStyle(fontSize: getProportionateScreenWidth(16)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.03),

          Text(
            "What sets us apart",
            style: TextStyle(
              color: Colors.black,
              fontSize: getProportionateScreenWidth(22),
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
              whoarewe.WhatSetsUsApart,
            style: TextStyle(fontSize: getProportionateScreenWidth(16)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          const Divider(color: Colors.black54),
          SizedBox(height: SizeConfig.screenHeight * 0.01),

      Row( children: [
        Text(
            "Contact Us",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          ],
      ),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          TextFormField(
            // enabled: false,
            initialValue: whoarewe.phone,
            readOnly: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.purple ,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
          ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.015),
          TextFormField(
            initialValue: whoarewe.email,
            readOnly: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.purple ,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
        ],
      ),
    ),
  ),
),
),
);
}
