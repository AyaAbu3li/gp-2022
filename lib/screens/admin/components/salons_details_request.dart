import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purple/Model/Serv.dart';
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
  Salon salon = Salon(
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '');
  bool circular = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void addSalon() async {
    try {
      var res = await http.patch(
          Uri.parse("http://" + ip + ":3000/salons/" + widget.text),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () =>
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => SalonsPage())),
                ),
              ],
            ),
      );
    } catch (e) {
      print(" hiiii");
      print(e);
    }
  }

  void deleteSalon() async {
    try {
      var res = await http.delete(
        Uri.parse("http://" + ip + ":3000/salons/" + widget.text),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () =>
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => SalonsRequests())),
                ),
              ],
            ),
      );
    } catch (e) {
      print(" hiiii");
      print(e);
    }
  }

  void fetchData() async {
    try {
      var res = await http.get(
        Uri.parse("http://" + ip + ":3000/salons/" + widget.text),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
      );
      setState(() {
        var decoded = json.decode(res.body);
        salon.name = decoded['name'];
        salon.email = decoded['email'];
        salon.picture = decoded['picture'];
        salon.city = decoded['city'];
        salon.phone = decoded['phone'].toString();
        salon.closeTime = decoded['closeTime'];
        salon.holiday = decoded['holiday'];
        salon.openTime = decoded['openTime'];
        salon.address = decoded['address'];
        salon.googlemaps = decoded['googlemaps'];
      });
      circular = false;
    } catch (e) {
      print(" hiiii");
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(salon.name+' Salon details'),
        ),
        body: circular
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
              child:
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.all(0),
                      child:
                      Image.asset( salon.picture,
                        height: 200,width: 480,fit: BoxFit.cover,),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.only(left: 16,right: 12),
                          child:
                          Image.asset( salon.picture,
                              height: 180,width: 130,fit: BoxFit.fill),
                        ),
                        Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Text(
                                    salon.name,
                                    style: TextStyle(color: Colors.purple.shade900,fontSize: 24,),textAlign: TextAlign.left,),
                                )),

                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Divider(
                        color: Colors.black54,
                        indent: 0,
                        endIndent: 0
                    ),
                    SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),

                          child: Row(
                            children: [
                              Icon(Icons.place,size: 26,color: Colors.purple.shade500,),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Text(
                                      salon.city,
                                      style:TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left),
                                  SizedBox(height: 3),

                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          salon.address,
                                          style:TextStyle(color: Colors.black87,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left)
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),

                          child: Row(
                            children: [
                              Icon(Icons.access_time_sharp,size: 26,color: Colors.purple.shade500),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "Opening Hours",
                                          style:TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left)
                                  ),

                                  SizedBox(height: 4),

                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "${salon.openTime} AM - ${salon.closeTime} PM",
                                          style:TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left)
                                  ),
                                ],
                              ),
                              SizedBox(width: 30),
                              Icon(Icons.today_sharp,size: 26,color: Colors.purple.shade500),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Excluded days",
                                        style:TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 17,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,)),

                                  SizedBox(height: 4),

                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          salon.holiday,
                                          style:TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left)
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),

                          child: Row(
                            children: [
                              Icon(Icons.phone,size: 26,color: Colors.purple.shade500,),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "Phone",
                                          style:TextStyle(color: Colors.black.withOpacity(0.6),
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left)
                                  ),
                                  SizedBox(height: 4),

                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          salon.phone,
                                          style:TextStyle(color: Colors.black87,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,),
                                          textAlign: TextAlign.left)
                                  ),
                                ],
                              ),
                              SizedBox(width: getProportionateScreenWidth(55)),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),

                          child: Row(
                              children: [
                                Icon(Icons.location_on_outlined,size: 26,color: Colors.purple.shade500,),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: (){
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => services()));
                                  },
                                  child: Text("View location in google maps",
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(12),
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.purple.shade500,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    Divider(
                      color: Colors.black54,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
        ),
      );
}
  double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = 500;
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }
}
class Employee{
  final String picture;
  final String name;
  final String job;

  const Employee({
    required this.picture,
    required this.name,
    required this.job,
  });
  static Employee fromJson(json) => Employee(
    name: json['name'],
    picture: json['picture'],
    job: json['job'],
  );
}

class Servicee {
  final String name;
  final String price;
  final String category;

  Servicee({
    required this.name,
    required this.price,
    required this.category,
  });
  static Servicee fromJson(json) => Servicee(
    name: json['name'],
    price: json['price'].toString(),
    category: json['category'],
  );
}


Widget buildCard({
  required Employee employees,
}) => Container(
  width: 113,
  child: Column(
    children: [
      Expanded(
        child:  AspectRatio(
          aspectRatio: 4/3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.asset(
              employees.picture,
              fit: BoxFit.cover,
            ),
          ),
        ),),

      const SizedBox(height: 4),
      Text(
        employees.name,
        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      Text(
        employees.job,
        style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,),
      ),
    ],
  ),
);


Widget buildCardS({
  required Servicee servicee,
}) => Container(
  width: double.infinity,
  color: Colors.grey.withOpacity(0.1),
  height: 37,

  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(
          servicee.name,
          style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87.withOpacity(0.7)),
        ),
      ),

      Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: Text("₪"
            +servicee.price,
          style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent),
        ),
      ),
    ],
  ),
);


class ItemListt extends StatelessWidget{
  final List<Serv> c;
  const ItemListt(Key key ,  this.c) :super(key: key);
  @override
  Widget build(BuildContext context){
    return Column(
      children: c.map((e) => ItemCard(serv: e,)).toList(),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Serv serv;

  const ItemCard( {Key? key,  required this.serv}) : super(key : key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Row(
        children: [
          Container (
            width: 100,
            child: Text("hi"),
          ) ,
        ],

      ),
    );
  }
}


class  Info {
  final String name;
  final String value;

  const Info( {
    required this.name,
    required this.value,
  }  );

  static Info fromJson(json) => Info(
    name: json['name'],
    value: json['value'],
  );
}
