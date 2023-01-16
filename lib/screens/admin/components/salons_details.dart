import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purple/Model/Serv.dart';
import 'package:purple/Model/category.dart';
import 'package:purple/screens/admin/components/salons_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:math';
import '../../../Model/Rating.dart';
import '../../../Model/salon.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class salonsdetails extends StatefulWidget {
  final String text;
  const salonsdetails(this.text);

@override
State<salonsdetails> createState() => _salonsdetailsState();
}
class _salonsdetailsState extends State<salonsdetails> {
  Salon salon = Salon('','','','','','','','','','','','');
  List<Employee> employees = [];
  List<Category> cate = [];
  List<Servicee> serviceee = [];
  List<Servicee> serviceeCategory = [];
  List<Rating> RatingS = [];

  bool serviceempty = false;
  bool empEmpty = false;
  int num = 0;
  bool circular = true;

  @override
  void initState() {
    super.initState();
    fetchData();
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

  Future<void> _openmap() async {
    await canLaunchUrlString(salon.googlemaps)
        ? await launchUrlString(salon.googlemaps)
        : throw 'could not launch ${salon.googlemaps}';
  }


  void fetchData() async {
    var data2;
    var cat;
    var ser;
    var rat;
    try{
      var res = await http.get(Uri.parse("http://"+ip+":3000/salons/"+widget.text),
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

      var res2 = await http.get(Uri.parse("http://"+ip+":3000/employee/"+salon.name),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
      );
      data2 = json.decode(res2.body);
      setState(() {
        this.employees = data2.map<Employee>(Employee.fromJson).toList();
        if(employees.isEmpty){
          empEmpty = true;
        }

      });

      var res3 = await http.get(Uri.parse("http://"+ip+":3000/category/"+salon.email),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
      );
      cat = json.decode(res3.body);

      setState(() {
        this.cate = cat.map<Category>(Category.fromJson).toList();
        currentCategory = cate[0].category;
      });

      var res4 = await http.get(Uri.parse("http://"+ip+":3000/services/"+salon.email),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
      );
      ser = json.decode(res4.body);
      setState(() {
        this.serviceee = ser.map<Servicee>(Servicee.fromJson).toList();
        this.serviceeCategory = ser.map<Servicee>(Servicee.fromJson).toList();
        serviceeCategory.removeWhere((data) => data.category != currentCategory);
        if(serviceee.isEmpty){
          serviceempty = true;
        }
      });

      var res5 = await http.get(Uri.parse("http://"+ip+":3000/rating/"+salon.email),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
      );
      rat = json.decode(res5.body);
      setState(() {
        this.RatingS = rat.map<Rating>(Rating.fromJson).toList();
        if(RatingS.isEmpty){
          num = 0;
          return;
        }

        for(int i=0; i<RatingS.length; i++){
          items.add(RatingS[i].rating);
        }
        num = items.reduce(max);

      });

      circular = false;

    } catch(e){
      print(" hiiii");
      print(e);
    }
  }
  void fun() async {
    var ser;

    var res4 = await http.get(Uri.parse("http://"+ip+":3000/services/"+salon.email),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    ser = json.decode(res4.body);
    setState(() {
      this.serviceee = ser.map<Servicee>(Servicee.fromJson).toList();
      this.serviceeCategory = ser.map<Servicee>(Servicee.fromJson).toList();
      serviceeCategory.removeWhere((data) => data.category != currentCategory);

    });

  }

  List<int> items = [];


  late String currentCategory;
  int current = 0;
  double rating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(salon.name),
        centerTitle: true,
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          :SafeArea(
        child:SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                EdgeInsets.all(0),
                child:
                Image.network( salon.picture,
                  height: 200,width: 480,fit: BoxFit.cover,),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding:
                    EdgeInsets.only(left: 16,right: 12),
                    child:
                    Image.network(
                        salon.picture,
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
                      SizedBox(height: 50,
                          child:
                          RatingBarIndicator(
                              rating: this.num.toDouble(),
                              itemCount: 5,
                              itemSize: 30.0,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              )
                          )
                      ),
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
                                    "${salon.openTime} - ${salon.closeTime}",
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
                              _openmap();
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
              SizedBox( height: 10),

              empEmpty ? SizedBox(height: getProportionateScreenWidth(1))
                  :Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                            "Our Team :",
                            style: TextStyle(color: Colors.purple.shade900,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,),
                            textAlign: TextAlign.left),
                      )
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 130,
                    child: ListView.separated(
                      padding: EdgeInsets.all(6),
                      scrollDirection: Axis.horizontal,
                      itemCount: employees.length,
                      separatorBuilder: (context, _) => SizedBox(width: 18),
                      itemBuilder: (context,index) => buildCard(employees: employees[index]),

                    ),
                  ),
                  SizedBox(height: 6),
                  Divider(
                    color: Colors.black54,
                    indent: 0,
                    endIndent: 0,
                  ),
                  SizedBox(height: 14),
                ],
              ),
              serviceempty ? SizedBox(height: getProportionateScreenWidth(1))
                  :Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                            "Service we provide:",
                            style: TextStyle(color: Colors.purple.shade900,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left),
                      )
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin:  const EdgeInsets.all(0),
                    height: 300,
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ListView.builder(
                              itemCount: cate.length,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx,index){
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          current= index;
                                          currentCategory = cate[index].category;
                                          fun();
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: EdgeInsets.all(4),
                                        width: 100,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            borderRadius : BorderRadius.circular(8),
                                            color: current == index
                                                ? Colors.purple.withOpacity(0.3)
                                                : Colors.grey.withOpacity(0.2),
                                            border: current == index
                                                ?Border.all(
                                                color: Colors.purple,width: 2)
                                                : null
                                        ),
                                        child: Center(
                                          child: Text(
                                            cate[index].category,
                                            style: TextStyle(fontWeight: FontWeight.w600,
                                              color: current== index
                                                  ? Colors.black
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: current== index,
                                      child: Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.deepPurpleAccent
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          ),
                        ),

                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: ListView.separated(
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      scrollDirection: Axis.vertical,
                                      itemCount: serviceeCategory.length, // here**** current
                                      separatorBuilder: (context, _) => SizedBox(height: 8),
                                      itemBuilder: (context,index) => buildCardS(servicee: serviceeCategory[index]), // here****
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
