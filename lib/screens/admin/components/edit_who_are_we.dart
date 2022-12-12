import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:purple/screens/admin/components/who_are_we.dart';
import '../../../Model/Whoarewe.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;

class editWhoAreWe extends StatefulWidget {
const editWhoAreWe({Key? key}) : super(key: key);
@override
_editWhoAreWeState createState() => _editWhoAreWeState();
}

class _editWhoAreWeState extends State<editWhoAreWe> {
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
  void edit() async {
    try{
      var res = await http.patch(Uri.parse("http://"+ip+":3000/whoAreWe/63875089e605030b4d2f2476"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
          },
          body: <String, String>{
            'phone': whoarewe.phone,
            'whoAreWe': whoarewe.whoAreWe,
            'WhatSetsUsApart': whoarewe.WhatSetsUsApart ,
            // 'picture': user.picture
          });
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('modified'),
              content: Text("Your information has been successfully modified"),
              actions: [
                TextButton(
                  child: Text('OK',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        color: Colors.white,)),
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => whoAreWe()) ),
                ),
              ],
            ),
      );
    } catch(e){
      print(" hiiii");
      print(e);
    }
  }
@override
Widget build(BuildContext context) => Scaffold(
appBar: AppBar(
title: const Text('Edit who are we page'),
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
  Row( children: [
    Image.asset(whoarewe.picture,width: 200,height: 160,),
    SizedBox( width: 20.0),
    TextButton(
      style: TextButton.styleFrom(
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {

      },
      child: Text("Edit Image",
        style: TextStyle(
          fontSize: getProportionateScreenWidth(18),
          color: Colors.white,),
      ),
    ),
  ]
  ),

  SizedBox(height: SizeConfig.screenHeight * 0.01),
  const Divider(color: Colors.black54),
  SizedBox(height: SizeConfig.screenHeight * 0.01),

  Row( children: [
  Text(
    "Who are we?",
    style: TextStyle(
      color: Colors.black,
      fontSize: getProportionateScreenWidth(22),
      fontWeight: FontWeight.bold,
    ),
  ),
],),

  TextFormField(
    initialValue: whoarewe.whoAreWe,
    onChanged: (value) {
      if (value.isNotEmpty) {
        whoarewe.whoAreWe = value;
      }
    },
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      labelStyle: TextStyle(color: Colors.black),
    ),
    minLines: 6,
    maxLines: null,
  ),
  SizedBox(height: SizeConfig.screenHeight * 0.03),

  Row( children: [

    Text(
      "What sets us apart",
      style: TextStyle(
        color: Colors.black,
        fontSize: getProportionateScreenWidth(22),
        fontWeight: FontWeight.bold,
      ),
    ),
  ],),
  TextFormField(
    initialValue: whoarewe.WhatSetsUsApart,
    onChanged: (value) {
      if (value.isNotEmpty) {
        whoarewe.WhatSetsUsApart = value;
      }
    },
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      labelStyle: TextStyle(color: Colors.black),
    ),
    minLines: 6,
    maxLines: null,
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
  ],),
  SizedBox( height: 10.0),
  TextFormField(
    initialValue: whoarewe.phone,
    keyboardType: TextInputType.number,
    onChanged: (value) {
      if (value.isNotEmpty) {
        whoarewe.phone = value;
      }
    },
    decoration: const InputDecoration(
      prefixIcon: Icon(
        Icons.phone,
        color: Colors.purple ,
      ),
      border: UnderlineInputBorder(),
    ),
  ),
  SizedBox( height: 15.0),

  TextFormField(
    initialValue: whoarewe.email,
    readOnly: true,
    keyboardType: TextInputType.emailAddress,
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
  SizedBox(height: SizeConfig.screenHeight * 0.03),
  DefaultButton(
    text: "Save",
    press: () {
      edit();
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