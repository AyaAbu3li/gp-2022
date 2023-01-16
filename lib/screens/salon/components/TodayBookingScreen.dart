import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:purple/global.dart' as global;
import 'package:purple/screens/salon/salon_screen.dart';
import 'dart:convert';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../Model/salon.dart';
import 'AppointmentPage.dart';


class TodayBookingScreen extends StatefulWidget {
  const TodayBookingScreen({Key? key}) : super(key: key);
  @override
  State<TodayBookingScreen> createState() => _TodayBookingScreenState();
}

class _TodayBookingScreenState extends State<TodayBookingScreen>  {
  List<Booking> appoint = [];
  List<Booking> appoint2 = [];
  bool circular = true;
  bool circular2 = true;
  bool circulaMain = true;
  Salon salon = Salon('','','','','','','','','','','','');
  int holiday=2;
  final controller = TextEditingController() ;

  List<Servicee> service = [];
  Map<Booking, List<Servicee>> _map_appoint = Map();
  Map<Booking, List<Servicee>> _map_appoint2 = Map();

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
      for(int x = 1; x<days.length; x++){
        if(days[x]==salon.holiday){
          setState(() {
            holiday = x;
          });
          break;
        }
      }


      var res = await http.get(Uri.parse("http://" + ip + ":3000/Allbooking"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      data = json.decode(res.body);
      setState(() {
        this.appoint = data.map<Booking>(Booking.fromJson).toList();
        appoint.removeWhere((data) =>
        data.date.toString().split(" ")[0] != DateTime.now().toString().split(" ")[0]);

        this.appoint2 = data.map<Booking>(Booking.fromJson).toList();
        appoint2.removeWhere((data) =>
        data.date.toString().split(" ")[0] != DateTime.now().toString().split(" ")[0]);
      });

      appoint.sort((a, b){
        return int.parse(a.time.toString().split(":")[0]).compareTo(int.parse(b.time.toString().split(":")[0]));
        //softing on numerical order (Ascending order by Roll No integer)
      });

      appoint.sort((a, b){
        return a.time.toString().split(" ")[1].compareTo(b.time.toString().split(" ")[1]);
        //softing on alphabetical order (Ascending order by Name String)
      });

      if (appoint.isNotEmpty) {
        for (int x = 0; x < appoint.length; x++) {

          var res2 = await http.get(Uri.parse(
              "http://" + ip + ":3000/bookingServices/" + appoint[x].id),
              headers: <String, String>{
                'Context-Type': 'application/json;charSet=UTF-8',
              });
          var data2 = json.decode(res2.body);
          setState(() {
            this.service = data2.map<Servicee>(Servicee.fromJson).toList();
          });

          for (int j = 0; j < service.length; j++) {
            _map_appoint.putIfAbsent(appoint[x], () => <Servicee>[]).add(
                service[j]);
            _map_appoint2.putIfAbsent(appoint[x], () => <Servicee>[]).add(
                service[j]);
          }
        }
      }





      if (appoint.isNotEmpty) {
        circular = false;
      } else circular = true;
      circular2 = false;

      circulaMain = false;
    }catch (e) {
      print("get");
      print(e);
    }
    }

  List<String> days = ["",
    "monday", "tuesday" , "wednesday",
    "thursday", "friday", "saturday", "sunday"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todays Appointments'),
      ),
      body:
      circulaMain
        ? Center(child: CircularProgressIndicator())
        :
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            circular ?
            Center(child:
              Text("No Appointments on this day",
                style: TextStyle(fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)))
            : circular2 ? Center(child: CircularProgressIndicator())
           : Padding(
             padding: EdgeInsets.only(left: 20, right: 20),
              child:
                  Container(child: buildAppointment(appoint)),
           ),
        ],
        ),
      ),
    );
  }

  Widget buildAppointment(List<Booking> saloons) =>
      ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: saloons.length,
        itemBuilder: (context, index) {
          final saloon = saloons[index];
          return Column(
            children: [
              Card(
                elevation: 40,
                child: Container(
                  height: 350,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.only(left: 16, right: 12),
                            child:
                            Image.network(saloon.PersonPic,
                                height: 100, width: 100, fit: BoxFit.fill),
                          ),
                          Column(
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Text(
                                      saloon.PersonName,
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
                                  saloon.role == 10 ? // not approved
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
                                  : saloon.role == 1 ?  //  approved
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
                                  SizedBox(
                                    width: getProportionateScreenWidth(50),
                                    child:
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>
                                                AppointmentPage(saloon.id)));
                                      },
                                      child: Text("Edit",
                                        style: TextStyle(
                                          color: Colors.white,),
                                      ),
                                    ),
                                  ),
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
                                          saloon.date.toString().split(" ")[0],
                                          style: TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left)
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          DateFormat('EEEE').format(saloon.date),
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
                                        saloon.time,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30),
                        child:
                        Container(
                          height:100,
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
                                    itemCount: _map_appoint[saloon]!.length,
                                    separatorBuilder: (context, _) =>
                                        SizedBox(height: 10),
                                    itemBuilder: (BuildContext context, int index) =>
                                        ServiceItem2(
                                            serv: _map_appoint[saloon]![index]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 0,
                        endIndent: 0,
                      ),
                      SizedBox(height: 5),
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
                                + saloon.price,
                              style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox( height: 15),
            ],
          );
        },
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


class Booking {
  final String PersonName;
  final String phoneNumber;
  final String SalonName;
  final String SalonEmail;
  final String SalonPic;
  final String PersonPic;
  final String price;
  final DateTime date;
  final String time;
  final String id;
  final int role;
  final String owner;

  const Booking({
    required this.PersonName,
    required this.phoneNumber,
    required this.SalonName,
    required this.SalonEmail,
    required this.PersonPic,
    required this.SalonPic,
    required this.price,
    required this.date,
    required this.time,
    required this.id,
    required this.role,
    required this.owner,

  });

  static Booking fromJson(json) => Booking(
    PersonName: json['PersonName'],
    phoneNumber: json['phoneNumber'],
    SalonName: json['SalonName'],
    SalonEmail: json['SalonEmail'],
    date: DateTime.parse(json['date']),
    time: json['time'],
    price: json['price'],
    id: json['_id'],
    role: json['role'],
    PersonPic: json['PersonPic'],
    SalonPic: json['SalonPic'],
    owner: json['owner'],
  );}
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



