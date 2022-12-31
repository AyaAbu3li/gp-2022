import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../admin_screen.dart';
import 'package:http/http.dart' as http;
import 'offer_page.dart';

class offerRequests extends StatefulWidget {
  const offerRequests({Key? key}) : super(key: key);
  @override
  State<offerRequests> createState() => _offerRequestsState();
}
class _offerRequestsState extends State<offerRequests> {
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
        offer.removeWhere((data) => data.role == 1);
        if(offer.isEmpty){
           empty = true;

          // showDialog(
          //   context: context,
          //   builder: (context) =>
          //       AlertDialog(
          //         title: Text('come back later'),
          //         content: Text("There are no offer requests at the moment"),
          //         actions: [
          //           TextButton(
          //             child: Text('OK',
          //                 style: TextStyle(
          //                   fontSize: getProportionateScreenWidth(14),
          //                   color: Colors.white,)),
          //             style: TextButton.styleFrom(
          //               backgroundColor: kPrimaryColor,
          //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          //             ),
          //             onPressed: () =>  Navigator.push(
          //                 context, MaterialPageRoute(builder: (context) => adminScreen())),
          //           ),
          //         ],
          //       ),
          // );
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
      appBar: AppBar(title: const Text('Offer requests')),
      body:circular
          ? Center(child: CircularProgressIndicator())
          : empty
          ? Center(child: Text("No Requests yet!",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black)))
          :  Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all( 15,),
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
            print("Container clicked");
            Navigator.push(context, MaterialPageRoute(builder: (context) => Offer_Page(offerr.id.toString())));
          },
          child: Container(
            height: 230,
            //  color: Colors.purple.withOpacity(0.15),
            child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child:
                    Image.asset(offerr.picture, height: 130,width: 500,fit: BoxFit.cover,),
                  ),
                  Text(offerr.Salon,style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold)),
                  Text(offerr.name,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
    // price: json['description'],
    picture: json['picture'],
    Salon: json['salonname'],
    role: json['role'],
    id: json['_id'],

  );
}
