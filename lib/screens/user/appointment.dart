import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:purple/global.dart' as global;
import 'package:purple/screens/user/HomeScreen.dart';
import 'dart:convert';
import '../../constants.dart';
import '../../size_config.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);
  @override
  State<Appointment> createState() => _AppointmentState();
}
void deleteAppointment(id) async {
  try{
    var res = await http.patch(Uri.parse("http://"+ip+":3000/booking/"+id),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
        body: <String, String>{
          'role': '11',
        });

  } catch(e){
    print("hiiii delete");
    print(e);
  }
}
class _AppointmentState extends State<Appointment> {
  List<Booking> appoint = [];
  List<Booking> history = [];
  bool circular = true;
  bool circular2 = true;
  bool circulaMain = true;

  List<Servicee> service = [];
  Map<Booking, List<Servicee>> _map_appoint = Map();
  Map<Booking, List<Servicee>> _map_history = Map();

  @override
  void initState() {
    super.initState();
    getAppointment();
  }

  void getAppointment() async {
    var data;
    try {
      var res = await http.get(Uri.parse("http://" + ip + ":3000/booking"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      data = json.decode(res.body);
      setState(() {
        this.appoint = data.map<Booking>(Booking.fromJson).toList();
        this.history = data.map<Booking>(Booking.fromJson).toList();

        appoint.removeWhere((data) => data.role != 0);
        history.removeWhere((data) => data.role == 0);
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
        }
      }
    }
      if (history.isNotEmpty) {
        for (int x = 0; x < history.length; x++) {
          var res2 = await http.get(Uri.parse(
              "http://" + ip + ":3000/bookingServices/" + history[x].id),
              headers: <String, String>{
                'Context-Type': 'application/json;charSet=UTF-8',
              });
          var data2 = json.decode(res2.body);
          setState(() {
            this.service = data2.map<Servicee>(Servicee.fromJson).toList();
          });

          for (int j = 0; j < service.length; j++) {
            _map_history.putIfAbsent(history[x], () => <Servicee>[]).add(
                service[j]);
          }
        }
      }
      if (appoint.isNotEmpty) {
        circular = false;
      }
      if (history.isNotEmpty) {
        circular2 = false;
      }
      circulaMain = false;
    } catch (e) {
      print("hiiii");
      print(e);
    }
  }

  String num = "678";

  @override
  Widget build(BuildContext context) {
    return
      DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 10,
            title: const Text('My Appointments'),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'History')
              ],
            ),
          ),
          body: circulaMain ?
          Center(child: CircularProgressIndicator()) :
          TabBarView(
            children: [
              circular
                  ? Center(child: Text("No Appointments yet!",
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold,
                      color: Colors.black)))
                  : Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: double.infinity,
                  child: buildAppointment(appoint),
                ),
              ),
              circular2
                  ? Center(child: Text("No Appointments yet!",
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold,
                      color: Colors.black)))
                  : Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: double.infinity,
                  child: buildAppointmentHistory(history),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget buildAppointment(List<Booking> saloons) =>
      ListView.builder(
        itemCount: saloons.length,
        itemBuilder: (context, index) {
          final saloon = saloons[index];
          return Card(
            elevation: 40,
            child: Container(
              height: 400,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.only(left: 16, right: 12),
                        child:
                        Image.asset(saloon.SalonPic,
                            height: 100, width: 100, fit: BoxFit.fill),
                      ),
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Text(
                                  saloon.SalonName,
                                  style: TextStyle(
                                    color: Colors.purple.shade900, fontSize: 24,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )
                          ),

                          SizedBox(height: 10),
                          Container(
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
                          )
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

                  SizedBox(height: getProportionateScreenHeight(100),
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30),
                      child:
                      Column(
                        children: [
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _map_appoint[saloon]!.length,
                            separatorBuilder: (context, _) =>
                                SizedBox(height: 10),
                            itemBuilder: (BuildContext context, int index) =>
                                ServiceItem2(
                                    serv: _map_appoint[saloon]![index]),
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
                  SizedBox(height: 5),

                  Divider(
                    color: Colors.grey,
                    indent: 0,
                    endIndent: 0,
                  ),
                  SizedBox(height: 5),
                Padding(
                padding: const EdgeInsets.only(left: 20.0),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style:
                        ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            textStyle:
                            const TextStyle(fontSize: 15)),
                        child: const Text('Cancel booking'),

                        onPressed: () {
                          deleteAppointment(saloon.id);
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  title: Text('Canceled'),
                                  content: Text(
                                      "The appointment has been successfully canceled"),
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
                                              builder: (context) => HomeScreen(0))),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),

                  ],
                  ),
                 ),
                ],
              ),
            ),
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

  Widget buildAppointmentHistory(List<Booking> saloons) =>
      ListView.builder(
        itemCount: saloons.length,
        itemBuilder: (context, index) {
          final saloon = saloons[index];
          return Card(
            elevation: 40,
            child: Container(
              height: 400,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.only(left: 16, right: 12),
                        child:
                        Image.asset(saloon.SalonPic,
                            height: 100, width: 100, fit: BoxFit.fill),
                      ),
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Text(
                                  saloon.SalonName,
                                  style: TextStyle(
                                    color: Colors.purple.shade900, fontSize: 24,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )
                          ),

                          SizedBox(height: 10),
                          saloon.role == 10 ?
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
                         :  saloon.role == 11 ?
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Colors.red, // red , green
                            ),
                            child:
                            Text('CANCELD',
                                style:
                                TextStyle(
                                    fontSize: 15,
                                    color: Colors.white
                                )
                            ),
                          )
                         :Container(
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
                  SizedBox(height: getProportionateScreenHeight(100),
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30),
                      child:
                      Column(
                        children: [
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _map_history[saloon]!.length,
                            separatorBuilder: (context, _) =>
                                SizedBox(height: 10),
                            itemBuilder: (BuildContext context, int index) =>
                                ServiceItem2(
                                    serv: _map_history[saloon]![index]),
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
          );
        },
      );
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
