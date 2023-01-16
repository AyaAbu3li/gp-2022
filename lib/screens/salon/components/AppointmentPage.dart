import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Model/Booking.dart';
import '../../../Model/salon.dart';
import '../../../Model/user.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;

import '../salon_screen.dart';

class AppointmentPage extends StatefulWidget {
  final String text;
  const AppointmentPage(this.text);
  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}
void deleteAppointment(String id) async {
  try{
    var res = await http.patch(Uri.parse("http://"+ip+":3000/booking/"+id),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
        body: <String, String>{
          'role': '10',
        });

  } catch(e){
    print("hiiii delete");
    print(e);
  }
}
void APPROVEAppointment(String id) async {
  try{
    var res = await http.patch(Uri.parse("http://"+ip+":3000/booking/"+id),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
        body: <String, String>{
          'role': '1',
        });

  } catch(e){
    print(" APPROVE Appointment");
    print(e);
  }
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<Servicee> service = [];

  String errorNameImg ="assets/icons/white.svg";
  String namme ='';
  Salon salon = Salon('','','','','','','','','','','','');
  Booking book = Booking('','','',0,'','','','','','');
  User user = User('', '','','','','');

  @override
  void initState() {
    super.initState();
    getAppointment();
  }

  void getAppointment() async {

    var data;
    try {

      var ress = await http.get(Uri.parse("http://"+ip+":3000/salon"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      setState(() {
        var decoded = json.decode(ress.body);
        salon.name = decoded['name'];
        salon.email = decoded['email'];
        salon.picture = decoded['picture'];
        salon.city = decoded['city'];
        salon.phone = decoded['phone'].toString();
        salon.closeTime = decoded['closeTime'];
        salon.holiday = decoded['holiday'].toLowerCase();
        salon.openTime = decoded['openTime'];
        salon.address = decoded['address'];
        salon.googlemaps = decoded['googlemaps'];
      });


      var res = await http.get(Uri.parse("http://" + ip + ":3000/booking/"+widget.text),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
      );

      setState(() {
        data = json.decode(res.body);
        book.PersonName = data['PersonName'];
        book.role = data['role'];
        book.price = data['price'];
        book.phoneNumber = data['phoneNumber'];
        book.SalonName = data['SalonName'];
        book.SalonEmail = data['SalonEmail'];
        book.date = data['date'].split("T")[0];
        book.time = data['time'];
        book.owner = data['owner'];
        book.id = data['_id'];
      });

      var rees = await http.get(Uri.parse("http://"+ip+":3000/userID/"+book.owner),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      setState(() {
        var decoded = json.decode(rees.body);
        user.name = decoded['name'];
        user.picture = decoded['picture'];
      });

          var res2 = await http.get(Uri.parse(
              "http://" + ip + ":3000/bookingServices/" + widget.text),
              headers: <String, String>{
                'Context-Type': 'application/json;charSet=UTF-8',
              });
          var data2 = json.decode(res2.body);
          setState(() {
            this.service = data2.map<Servicee>(Servicee.fromJson).toList();
          });

      circular = false;

    }catch (e) {
      print("get");
      print(e);
    }
  }
  bool circular = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Alerts'),
    ),
    body: circular
        ? Center(child: CircularProgressIndicator())
        :
    SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(left: 16, right: 12),
                              child:
                              Image.network(user.picture,
                                  height: 100, width: 100, fit: BoxFit.fill),
                            ),
                            Column(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Text(
                                        user.name,
                                        style: TextStyle(
                                          color: Colors.purple.shade900, fontSize: 24,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    book.role == 10 ? // not approved
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        color: Colors.redAccent, // red , green
                                      ),
                                      child:
                                      Text('NOT APPROVED',
                                          style:
                                          TextStyle(
                                              fontSize: 15,
                                              color: Colors.white
                                          )
                                      ),
                                    )
                                        : book.role == 1 ?  //  approved
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        color: Colors.green, // red , green
                                      ),
                                      child:
                                      Text('APPROVED',
                                          style:
                                          TextStyle(
                                              fontSize: 15,
                                              color: Colors.white
                                          )
                                      ),
                                    )
                                        : Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        color: Colors.orange, // red , green
                                      ),
                                      child:
                                      Text('PENDING',
                                          style:
                                          TextStyle(
                                              fontSize: 15,
                                              color: Colors.white
                                          )
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 12),
                          child:
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: new BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child:
                            Row(
                              children: [
                                Icon(Icons.today_sharp, size: 26,
                                    color: Colors.purple.shade500),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            book.date.toString().split(" ")[0],
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left)
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            DateFormat('EEEE').format(DateTime.parse(book.date)),
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.left)
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30),
                                Icon(Icons.access_time_sharp, size: 26,
                                    color: Colors.purple.shade500),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          book.time,
                                          style:
                                          TextStyle(
                                            color: Colors.black.withOpacity(0.6),
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text('Payment',
                                style: TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87.withOpacity(0.7)),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: Text("₪"
                                  + book.price,
                                style: TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurpleAccent),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                          indent: 0,
                          endIndent: 0,
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, right: 30),
                          child:
                          Container(
                            height:200,
                            width: double.infinity,
                            child:
                            Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    child:
                                    ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      // shrinkWrap: true,
                                      itemCount: service.length,
                                      separatorBuilder: (context, _) =>
                                          SizedBox(height: 10),
                                      itemBuilder: (BuildContext context, int index) =>
                                          ServiceItem2(
                                              serv: service[index]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(left: 16, right: 12),
                          child:
                          Row(
                            children: [
                              SizedBox(
                                width: SizeConfig.screenWidth *0.4,
                                height: getProportionateScreenHeight(56),
                                child:
                                ElevatedButton(
                                  style:
                                  ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      textStyle:
                                      TextStyle(fontSize: getProportionateScreenWidth(18),
                                      )),
                                  child: const Text('APPROVE'),

                                  onPressed: () {
                                    APPROVEAppointment(book.id);
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AlertDialog(
                                            title: Text('APPROVED'),
                                            content: Text(
                                                "This appointment has been successfully APPROVED"),
                                            actions: [
                                              TextButton(
                                                child: Text('OK',
                                                    style: TextStyle(
                                                        fontSize: getProportionateScreenWidth(
                                                            14),
                                                        color: Colors.white)),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: kPrimaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(
                                                          15)),
                                                ),
                                                onPressed: () =>
                                                    Navigator.push(
                                                        context, MaterialPageRoute(
                                                        builder: (context) => salonScreen(0))),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: SizeConfig.screenWidth *0.4,
                                height: getProportionateScreenHeight(56),
                                child:
                                ElevatedButton(
                                  style:
                                  ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      textStyle:
                                      TextStyle(fontSize: getProportionateScreenWidth(16))),
                                  child: const Text('NOT APPROVED'),

                                  onPressed: () {
                                    deleteAppointment(book.id);
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AlertDialog(
                                            title: Text('NOT APPROVED'),
                                            content: Text(
                                                "This appointment has been successfully NOT APPROVED"),
                                            actions: [
                                              TextButton(
                                                child: Text('OK',
                                                    style: TextStyle(
                                                        fontSize: getProportionateScreenWidth(
                                                            14),
                                                        color: Colors.white)),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: kPrimaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(
                                                          15)),
                                                ),
                                                onPressed: () =>
                                                    Navigator.push(
                                                        context, MaterialPageRoute(
                                                        builder: (context) => salonScreen(0))),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                              ),
                              ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    ),
  );

  Widget ServiceItem2({required Servicee serv}) {
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              color: Colors.blueGrey,
            ),
            child:
            Text(serv.service,
                style:
                TextStyle(
                    fontSize: 15,
                    color: Colors.white
                )
            ),
          )
        ],
      );
  }


}
class Servicee {
  final String salonEmail;
  final String service;
  final String owner;

  Servicee({
    required this.salonEmail,
    required this.service,
    required this.owner,
  });
  static Servicee fromJson(json) => Servicee(
    salonEmail: json['salonEmail'],
    service: json['service'],
    owner: json['owner'],
  );
}

