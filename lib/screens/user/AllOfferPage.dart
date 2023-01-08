import 'package:flutter/material.dart';
import 'package:purple/screens/user/HomeScreen.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'OfferPage.dart';

class AllOferPage extends StatefulWidget {
  const AllOferPage({Key? key}) : super(key: key);
  @override
  State<AllOferPage> createState() => _AllOferPageState();
}
class _AllOferPageState extends State<AllOferPage> {
  List<Offer> offer = [];
  bool circular = true;
  bool offerempty = false;

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
        print(offer);
        if(offer.isEmpty){
          offerempty = true;

           // "There are no offers at the moment"

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
        title: const Text('Special Offers'),
        centerTitle: true,
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          :  offerempty
          ? Center(child:
            Text("No offers right now",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)))
          :Column(
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => OfferPage(offerr.id.toString())));
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
              ],
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
