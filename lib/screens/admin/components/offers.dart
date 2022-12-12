import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../admin_screen.dart';
import 'package:http/http.dart' as http;
import 'offer_page2.dart';

class offers extends StatefulWidget {
const offers({Key? key}) : super(key: key);
@override
State<offers> createState() => _offersState();
}
class _offersState extends State<offers> {
  List<Offer> offer = [];
  bool circular = true;

  @override
  void initState() {
    super.initState();
    getOffer();
  }
  void getOffer() async {
    var data;
    try{
      var res = await http.get(Uri.parse("http://"+ip+":3000/Alloffers"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
      );
      data = json.decode(res.body);
      setState(() {
        this.offer = data.map<Offer>(Offer.fromJson).toList();
        offer.removeWhere((data) => data.role == 0);
        if(offer.isEmpty){
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('come back later'),
                  content: Text("There are no offers at the moment"),
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
                          context, MaterialPageRoute(builder: (context) => adminScreen())),
                    ),
                  ],
                ),
          );
        }
        circular = false;
      });
    } catch(e){
      print(" hiiii");
      print(e);
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      backgroundColor: Colors.purple.shade300,
      elevation: 0,
      title: const Text(
        'All Offers',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    ),
    body: circular
        ? Center(child: CircularProgressIndicator())
        :  Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              child: buildOffers(offer),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildOffers(List<Offer> offerrss) => ListView.builder(
  itemCount: offerrss.length,
  itemBuilder: (context,index){
    final offerr = offerrss[index];
    return Card(
      elevation: 40,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Offer_Page2(offerr.id.toString())));
        },
        child: Container(
          height: 220,
          //  color: Colors.purple.withOpacity(0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child:
                Image.asset(offerr.picture, height: 130,width: 500,fit: BoxFit.cover,),
              ),
              Text(offerr.Salon,style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
              Text(offerr.name,style: TextStyle(fontSize: 20),),
            ]
          ),
        ),
      ),
    );
  },
);
}
class Offer {
  final String name;
  final int role;
  // final String price;
  final String picture;
  final String Salon;
  final String id;

  const Offer({
    required this.name,
    // required this.price,
    required this.picture,
    required this.Salon,
    required this.role,
    required this.id,

  });

  static Offer fromJson(json) => Offer(
    name: json['name'],
    // price: json['price'],
    picture: json['picture'],
    Salon: json['salonname'],
    role: json['role'],
    id: json['_id'],

  );
}