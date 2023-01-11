import 'package:flutter/material.dart';
import '../../size_config.dart';
import '../../Model/salon.dart';
import '../../Model/user.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;
import 'dart:collection';
import 'dart:convert';
import 'BookingScreen.dart';


class lastStep extends StatefulWidget {
  final String text;
  final String day;
  final int priceTotal;
  final DateTime today;
  final List<Servicee> selectedService1;
  const lastStep(this.text,this.today,this.day,this.selectedService1,this.priceTotal);
  @override
  State<lastStep> createState() => _lastStepState();
}

class _lastStepState extends State<lastStep> {

  User user = User('','','','','','');
  Salon salon = Salon('','','','','','','','','','','','');
  bool circular = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData() async {
    var res = await http.get(Uri.parse("http://"+ip+":3000/users/me"),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        'Authorization': global.token
      },
    );
    setState(() {

      var decoded = json.decode(res.body);
      user.name = decoded['name'];
      user.email = decoded['email'];
      user.picture = decoded['picture'];
      user.phone = decoded['phone'].toString();
    });

    var ress = await http.get(Uri.parse("http://"+ip+":3000/salons/"+widget.text),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    setState(() {
      var decoded = json.decode(ress.body);
      salon.name = decoded['name'];
      salon.email = decoded['email'];
    });

    circular = false;
  }



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: circular
            ? Center(child: CircularProgressIndicator())
            :
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: Container(
                  color: Colors.purple.withOpacity(0.04),
                  height: 540,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text(salon.name,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,

                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Thank you for booking our services!",
                          style: TextStyle(
                              fontSize: 19,
                              // fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.8)
                          )
                      ),
                      SizedBox(height: 10),
                      Text("BOOKING INFORMATION",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 16,),
                            Text(user.name, style: TextStyle(fontSize: 17),)
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 16,),
                            Text("Reservation Date :",
                                style: TextStyle(fontSize: 17)
                            ),
                            SizedBox(width: 16),
                            Text(widget.today.toString().split(" ")[0],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Row(
                          children: [
                            Icon(Icons.timelapse),
                            SizedBox(width: 16,),
                            Text("Reservation Time :", style: TextStyle(
                                fontSize: 17),),
                            SizedBox(width: 16,),
                            Text(widget.day, style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),),

                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Divider(
                        color: Colors.black54,
                        indent: 0,
                        endIndent: 0,
                      ),
                      SizedBox(height: 10),
                      Text("SERVICES BOOKED",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30),
                        child:
                        Column(
                          children: [
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: widget.selectedService1.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  ServiceItem2(serv: widget.selectedService1[index]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.black54,
                        indent: 0,
                        endIndent: 0,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("TOTAL PRICE",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black),
                            ),
                            SizedBox(width: 16),
                            Text("₪${widget.priceTotal}",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      // ),
    );
  }
  Widget ServiceItem2({required Servicee serv}){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(serv.name,
            style:
            TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.black.withOpacity(0.70)
            )
        ),
        SizedBox(width: 16),
        Text("₪${serv.price.toString()}",
          style:
          TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900),
        ),
      ],
    );
  }
}