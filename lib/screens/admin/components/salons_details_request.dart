import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purple/screens/admin/components/salons_page.dart';
import 'package:purple/screens/admin/components/salons_requests.dart';
import '../../../Model/salon.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class salonsdetailsRequest extends StatefulWidget {
  final String text;
  const salonsdetailsRequest(this.text);

  @override
  State<salonsdetailsRequest> createState() => _salonsdetailsRequestState();
}
class _salonsdetailsRequestState extends State<salonsdetailsRequest> {
  Salon salon = Salon('','','','','','','','','','','');
  bool circular = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void addSalon() async {
    try{
      var res = await http.patch(Uri.parse("http://"+ip+":3000/salons/"+widget.text),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
          body: <String, String>{
            'role': '1',
          });
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Done'),
              content: Text("The salon has been successfully added"),
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
                  onPressed: () =>  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SalonsPage())),
                ),
              ],
            ),
      );

    } catch(e){
      print(" hiiii");
      print(e);
    }
  }
  void deleteSalon() async {
    try{
      var res = await http.delete(Uri.parse("http://"+ip+":3000/salons/"+widget.text),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
      );
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Deleted'),
              content: Text("The salon has been successfully deleted"),
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
                  onPressed: () =>  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SalonsRequests())),
                ),
              ],
            ),
      );

    } catch(e){
      print(" hiiii");
      print(e);
    }
  }
  void fetchData() async {
    var res = await http.get(Uri.parse("http://"+ip+":3000/salons/"+widget.text),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    setState(() {
      var decoded = json.decode(res.body);
      salon.email = decoded['email'];
      salon.name = decoded['name'];
      salon.phone = decoded['phone'].toString();
      salon.address = decoded['address'];
      salon.city = decoded['city'];
      salon.googlemaps = decoded['googlemaps'];
      salon.picture = decoded['picture'];
      circular = false;
    });
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Salon details'),
    ),
    body: circular
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal:
          getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox( height: 10.0),
                Image.asset(salon.picture,width: 300,height: 200,),

                SizedBox(height: SizeConfig.screenHeight * 0.01),
                const Divider(color: Colors.black54),
                SizedBox(height: SizeConfig.screenHeight * 0.01),

                Row( children: [
                  Expanded(child:

                  Text(
                    "Salon name:",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: getProportionateScreenWidth(22),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  ),
                ],),

                Row( children: [
                  Expanded(child:

                  Text(
                    salon.name,
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                    textAlign: TextAlign.left,
                  ),
                  ),
                ],),

                SizedBox(height: SizeConfig.screenHeight * 0.01),
                const Divider(color: Colors.black54),
                SizedBox(height: SizeConfig.screenHeight * 0.01),

                // Row( children: [
                //   Expanded(child:
                //
                //   Text(
                //   "Salon details",
                //   style: TextStyle(
                //     color: Colors.purple,
                //     fontSize: getProportionateScreenWidth(22),
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                //   ),
                // ],),

                // Row( children: [
                //   Expanded(child:
                // Text(
                //   "Sign in with your email and passwordpasswordpasswordpasswordpassword ",
                //   style: TextStyle(
                //       fontSize: getProportionateScreenWidth(16)),
                //   textAlign: TextAlign.left,
                // ),
                //   ),
                // ],),

                // SizedBox(height: SizeConfig.screenHeight * 0.01),
                // const Divider(color: Colors.black54),
                // SizedBox(height: SizeConfig.screenHeight * 0.01),

                Row( children: [
                  Expanded(child:

                  Text(
                    "Salon phone number",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: getProportionateScreenWidth(22),
                      fontWeight: FontWeight.bold,
                    ),
                  ),),
                ],),

                Row( children: [
                  Expanded(child:

                  Text(
                    salon.phone,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(16)),
                    textAlign: TextAlign.left,
                  ),),
                ],),

                SizedBox(height: SizeConfig.screenHeight * 0.01),
                const Divider(color: Colors.black54),
                SizedBox(height: SizeConfig.screenHeight * 0.01),

                Row( children: [
                  Expanded(child:

                  Text(
                    "City",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: getProportionateScreenWidth(22),
                      fontWeight: FontWeight.bold,
                    ),
                  ),),
                ],),

                Row( children: [
                  Expanded(child:

                  Text(
                    salon.city,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(16)),
                    textAlign: TextAlign.left,
                  ),),
                ],),

                SizedBox(height: SizeConfig.screenHeight * 0.01),
                const Divider(color: Colors.black54),
                SizedBox(height: SizeConfig.screenHeight * 0.01),

                Row( children: [
                  Expanded(child:

                  Text(
                    "Address",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: getProportionateScreenWidth(22),
                      fontWeight: FontWeight.bold,
                    ),
                  ),),
                ],),

                Row( children: [
                  Expanded(child:

                  Text(
                    salon.address,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(16)),
                    textAlign: TextAlign.left,
                  ),),
                ],),

                SizedBox(height: SizeConfig.screenHeight * 0.01),
                const Divider(color: Colors.black54),
                SizedBox(height: SizeConfig.screenHeight * 0.01),

                Row( children: [
                  Expanded(child:

                  Text(
                    "location on google maps",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: getProportionateScreenWidth(22),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                ],),

                Row( children: [
                  Expanded(child:

                  Text(
                    salon.googlemaps,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(16)),
                    textAlign: TextAlign.left,
                  ),
                  ),
                ],),

                SizedBox(height: SizeConfig.screenHeight * 0.01),
                const Divider(color: Colors.black54),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(130),
                      child:
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          addSalon();
                          },
                        child: Text("Accept",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,),

                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.screenWidth * 0.04),
                    SizedBox(
                      width: getProportionateScreenWidth(130),
                      child:
                      TextButton(
                        style: TextButton.styleFrom(
                          // primary: Colors.purpleAccent, // foreground
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          deleteSalon();
                        },
                        child: Text("Reject",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,),

                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.screenHeight * 0.05),

              ],
            ),
          ),
        ),
      ),
    ),
  );
}