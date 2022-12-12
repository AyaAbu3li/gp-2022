import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;
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
    var res = await http.delete(Uri.parse("http://"+ip+":3000/booking/"+id),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );

  } catch(e){
    print("hiiii delete");
    print(e);
  }
}
class _AppointmentState extends State<Appointment> {
  List<Appointmentt> appoint = [];
  List<Appointmentt> history = [];
  bool circular = true;
  bool circular2 = true;

  @override
  void initState() {
    super.initState();
    getAppointment();
  }
  void getAppointment() async {
    var data;
    try{
      var res = await http.get(Uri.parse("http://"+ip+":3000/booking"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      data = json.decode(res.body);
      print(data);
      setState(() {
        this.appoint = data.map<Appointmentt>(Appointmentt.fromJson).toList();
        this.history = data.map<Appointmentt>(Appointmentt.fromJson).toList();

        appoint.removeWhere((data) => data.role == 1);
        history.removeWhere((data) => data.role == 0);

        if(appoint.isNotEmpty){
          circular = false;
        }
        if(history.isNotEmpty){
          circular2 = false;
        }

      });
    } catch(e){
      print("hiiii");
      print(e);
    }
  }

  String num = "678";

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.purple.shade300,
          elevation: 10,
          title: const Text('My Appointment ',
            style: TextStyle(fontSize: 18,
            // fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'History')
          ],
          ),
        ),
        body: TabBarView(
          children: [
            circular
                ? Center(child: Text("No Appointments yet!",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black)))
                :Padding(
                padding: const EdgeInsets.all(5.0),
                  child: Container(
                    child: buildAppointment(appoint),
                  ),
            ),
            circular2
                ? Center(child: Text("No Appointments yet!",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black)))
                :Padding(
                padding: const EdgeInsets.all(5.0),
                  child: Container(
                    child: buildAppointmentHistory(history),
                  ),
                ),
          ],
        ),
      ),
  );
  }

  Widget buildAppointment(List<Appointmentt> saloons) => ListView.builder(
    itemCount: saloons.length,
    itemBuilder: (context,index){
      final saloon = saloons[index];
      return Card(
        elevation: 40,
          child: Container(
            height: 330,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.blue.shade300,size: 40,),
                          Text(" Number: ", style: TextStyle(fontSize: 18,color: Colors.black))
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  indent: 30,
                  endIndent: 30,
                ),
               SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person),
                        Text("  Person Name: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                        Text(saloon.PersonName,style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        Text("  Phone Number: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                        Text(saloon.phoneNumber,style: TextStyle(fontSize: 18),maxLines: 2,),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.store),
                        Text("  Salon Name: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                        Text(saloon.SalonName,style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.home_repair_service_outlined),
                        Text("  Service Name: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                        Text(saloon.serviceName,style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.date_range_sharp),
                        Text("  The Date: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                        Text(saloon.date,style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.timelapse_outlined),
                        Text("  The Time: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                        Text(saloon.time,style: TextStyle(fontSize: 18))
                      ],
                    ),
                  Row(
                    children: [
                      Icon(Icons.attach_money),
                      Text("  Total Price: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                      Text(saloon.price,style: TextStyle(fontSize: 18))
                    ],
                  ),
                  ],
                ),
              ),

                SizedBox(height: 10),
                ElevatedButton(
                    onPressed: (){
                      deleteAppointment(saloon.id);
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: Text('Canceled'),
                              content: Text("The appointment has been successfully canceled"),
                              actions: [
                                TextButton(
                                  child: Text('OK',
                                      style: TextStyle(
                                          fontSize: getProportionateScreenWidth(14),
                                          color: Colors.white)),
                                  style: TextButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  ),
                                  onPressed: () =>  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => Appointment())),
                                ),
                              ],
                            ),
                      );
                    },
                     child:
                     Text('Cancel booking',
                          style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          color: Colors.white,),
                      ),
                ),
              ],
            ),
          ),
      );
    },
  );

Widget buildAppointmentHistory(List<Appointmentt> saloons) => ListView.builder(
  itemCount: saloons.length,
  itemBuilder: (context,index){
    final saloon = saloons[index];
    return Card(
      elevation: 40,
      child: Container(
        height: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.blue.shade300,size: 40,),
                      Text(" Number: ", style: TextStyle(fontSize: 18,color: Colors.black))
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              indent: 30,
              endIndent: 30,
            ),
            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person),
                      Text("  Person Name: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                      Text(saloon.PersonName,style: TextStyle(fontSize: 18))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone),
                      Text("  Phone Number: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                      Text(saloon.phoneNumber,style: TextStyle(fontSize: 18),maxLines: 2,),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.store),
                      Text("  Salon Name: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                      Text(saloon.SalonName,style: TextStyle(fontSize: 18))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.home_repair_service_outlined),
                      Text("  Service Name: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                      Text(saloon.serviceName,style: TextStyle(fontSize: 18))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.date_range_sharp),
                      Text("  The Date: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                      Text(saloon.date,style: TextStyle(fontSize: 18))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.timelapse_outlined),
                      Text("  The Time: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                      Text(saloon.time,style: TextStyle(fontSize: 18))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.attach_money),
                      Text("  Total Price: ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.purple)),
                      Text(saloon.price,style: TextStyle(fontSize: 18))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  },
);



class Appointmentt {
  final String PersonName;
  final String phoneNumber;
  final String SalonName;
  final String serviceName;
  final String price;
  final String date;
  final String time;
  final String id;
  final int role;

  const Appointmentt({
    required this.PersonName,
    required this.phoneNumber,
    required this.SalonName,
    required this.serviceName,
       required this.price,
       required this.date,
       required this.time,
       required this.id,
       required this.role,

  });

  static Appointmentt fromJson(json) => Appointmentt(
    PersonName: json['PersonName'],
    phoneNumber: json['phoneNumber'],
    SalonName: json['SalonName'],
    serviceName: json['serviceName'],
    date: json['date'],
    time: json['time'],
    price: json['price'],
    id: json['_id'],
    role: json['role'],

  );}


