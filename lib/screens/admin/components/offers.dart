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
  bool empty = false;

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
        offer.removeWhere((data) => data.enddate == DateTime.now().toString().split(" ")[0]);

        if(offer.isEmpty){
           empty = true;
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
      title: const Text('All Offers' ),
      centerTitle: true,
    ),
    body: circular
        ? Center(child: CircularProgressIndicator())
        : empty
        ? Center(child: Text("There are no offers\n at the moment",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black)))
        : Column(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child:
                Image.network(offerr.picture, height: 130,width: 500,fit: BoxFit.cover,),
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
  final String enddate;
  final String picture;
  final String Salon;
  final String id;

  const Offer({
    required this.name,
    required this.enddate,
    required this.picture,
    required this.Salon,
    required this.role,
    required this.id,

  });

  static Offer fromJson(json) => Offer(
    name: json['name'],
    enddate: json['enddate'],
    picture: json['picture'],
    Salon: json['salonname'],
    role: json['role'],
    id: json['_id'],

  );
}