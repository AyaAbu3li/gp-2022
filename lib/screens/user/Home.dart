import 'package:flutter/material.dart';
import 'package:purple/size_config.dart';
import '../../constants.dart';
import 'AllOfferPage.dart';
import 'AllSalonPage.dart';
import 'Notificat.dart';
import 'OfferPage.dart';
import 'package:purple/global.dart' as global;
import 'SalonPage.dart';
import 'NewSalonsPage.dart';
import 'appointment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Offer> offer = [];
  bool circular = true;
  List<Salon> saloon = [];
  List<Salon> citySaloon = [];

  @override
  void initState() {
    super.initState();
    getOffer();
    getSalons();

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

        }
      });
    } catch(e){
      print(" hiiii");
      print(e);
    }
  }
  void getSalons() async {
    var data;
    try{
      var res = await http.get(Uri.parse("http://"+ip+":3000/salons"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
      );
      data = json.decode(res.body);
      setState(() {

        this.citySaloon = data.map<Salon>(Salon.fromJson).toList();
        citySaloon.removeWhere((data) => data.city != global.city);

        this.saloon = data.map<Salon>(Salon.fromJson).toList();
        saloon.removeWhere((data) => data.role == 4);

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(10),),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Container(
                        width: (MediaQuery.of(context).size.width) * 0.7,
                        //height: 50,
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          onChanged:(value) {
                            // search code
                          },
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                           focusedBorder: InputBorder.none,
                            hintText: 'Srarch..',
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20),
                              vertical: getProportionateScreenWidth(9),
                            ),
                          ),
                        ),
                      ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:(context) => Notificat()) );
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Stack(
                        children: [
                          Container(
                            //   padding: EdgeInsets.all(getProportionateScreenWidth(1)),
                            height: getProportionateScreenWidth(40),
                            width: getProportionateScreenWidth(40),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child:   Icon(Icons.notification_important,size: 36,color: Colors.purple,),
                          ),
                        ],
                      ),
                    ),
                     // InkWell(
                     //   onTap: (){
                     //    Navigator.push(context, MaterialPageRoute(builder:(context) => Appointment()) );
                     //   },
                     //   borderRadius: BorderRadius.circular(50),
                     //   child: Stack(
                     //     children: [
                     //       Container(
                     //     //   padding: EdgeInsets.all(getProportionateScreenWidth(1)),
                     //         height: getProportionateScreenWidth(40),
                     //         width: getProportionateScreenWidth(40),
                     //         decoration: BoxDecoration(
                     //           color: Colors.grey.withOpacity(0.1),
                     //           shape: BoxShape.circle,
                     //         ),
                     //         child:  Icon(Icons.bookmark_added,size: 36,color: Colors.purple,),
                     //       ),
                     //     ],
                     //   ),
                     // ),
                  ],
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Padding(
                padding: EdgeInsets.only(left: 7,right: 16),
                child: Text('Find and book best services',
                style: TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black,
                  fontSize: 26),),
              ),

              const SizedBox(
                height: 30,
              ),
              
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                  ),
              ),

              Column(
                children: [
                  SectionTitle(
                      text: "Special Offers ",
                      press: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllOferPage()));
                      }
                  ),
                  SizedBox(
                    height: getProportionateScreenWidth(8),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildOffers(offer),
                        SizedBox(width: getProportionateScreenWidth(30)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenWidth(10),
                  ),
                  SectionTitle(
                      text: "Special Salons for you ",
                      press: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewSalonsPage()));
                      }
                  ),
                  SizedBox(
                    height: getProportionateScreenWidth(10),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                       ...List.generate(citySaloon.length, (index) =>
                           SalonCard(salon: citySaloon[index],
                       )
                       ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(30)),
                  SectionTitle(
                      text: "Salons",
                      press: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllSalonPage()));
                      }
                  ),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(saloon.length, (index) =>
                            SalonCard(salon: saloon[index])
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30)
                ],
              )
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

  Image logoWidget(String imageName){
    return Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 50,
      height: 50,
      //  color: Colors.black,

    );
  }


  Widget buildOffers(List<Offer> offerrss) => SizedBox(
    height: getProportionateScreenHeight(150),
    width: getProportionateScreenWidth(420),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: offerrss.length,
      itemBuilder: (context,index){
        final offerr = offerrss[index];
        return SpesialOfferCard(
              category: offerr.name,
              picture: offerr.picture,
              line2: offerr.Salon,
              press: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OfferPage(offerr.id.toString())));
              }
          );
      },
    ),
  );

}

class SectionTitle extends StatelessWidget{

  const SectionTitle({
    super.key, required this.text, required this.press,

  });

  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
  
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.w500,
              color: Colors.purple,
            ),
          ),
          GestureDetector(
            onTap: press,
            child: Text("See More",
              style: TextStyle(fontSize: 14,color: Colors.purple),),
          ),

        ],
      ),
    );
    
  }

  double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = 500;

    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }

  Image logoWidget(String imageName){
    return Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 50,
      height: 50,
      //  color: Colors.black,

    );
  }

}

class SpesialOfferCard extends StatelessWidget{

  const SpesialOfferCard({
    super.key,
    required this.category,
    required this.picture,
    required this.line2,
    required this.press,

  });
   final String category, picture;
   final String line2;
   final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding:  EdgeInsets.only(left: getProportionateScreenWidth(20)),
     child: GestureDetector(
       onTap: (){
         press();
         },
       child: SizedBox(
         width: getProportionateScreenWidth(190),
         height: getProportionateScreenWidth(100),
         child: ClipRRect(
           borderRadius: BorderRadius.circular(30),
           child:Stack(
             children: [
               Image.asset(picture, fit:BoxFit.cover,),
               Container(
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     begin:  Alignment.topCenter,
                     end: Alignment.bottomCenter,

                     colors: [
                       Color(0xFF343434).withOpacity(0.4),
                       Color(0xFF343434).withOpacity(0.15),
                     ],

                   ),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: getProportionateScreenWidth(15),
                   vertical: getProportionateScreenWidth(10),
                 ),
                 child: Text.rich(
                   TextSpan(
                     style:  TextStyle(color: Colors.white),
                     children: [
                       TextSpan(
                         text: "$category\n",
                         style: TextStyle(
                           fontSize: getProportionateScreenWidth(25),
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       TextSpan(text: line2 ,style: TextStyle(fontSize: 20)),
                     ],
                   ),
                 ),
               ),
             ],
           ),
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

  Image logoWidget(String imageName){
    return Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 50,
      height: 50,
      //  color: Colors.black,
    );
  }
}

class SalonCard extends StatelessWidget{
  const SalonCard({
    super.key,
    this.width = 150,
     this.aspectRetion= 1.02,
    required this.salon,
  });
  final double width, aspectRetion;
  final Salon salon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      // padding: EdgeInsets.all(10),

      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: aspectRetion,
              child: GestureDetector(
                onTap: (){
                  print("Container clicked");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SalonPage(salon.id.toString())));
                },
                child: Container(
                  // padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(salon.picture,fit: BoxFit.cover,),
                ),
              ),
            ),
            const SizedBox(height: 5),
                Column(
                  children: [
                    Text(
                      salon.name,
                      style: TextStyle(color: Colors.black, fontSize: 19,fontWeight: FontWeight.w600),
                      maxLines: 2,
                    ),
                    Text(
                      salon.city,
                      style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 16),
                      maxLines: 2,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = 500;
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }

  Image logoWidget(String imageName) {
    return Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 50,
      height: 50,
      //  color: Colors.black,
    );
  }

}


class Salon {
  final String name;
  final String city;
  final String picture;
  final String id;
  final int role;

  const Salon( {
    required this.name,
    required this.city,
    required this.picture,
    required this.id,
    required this.role,

  }  );


  static Salon fromJson(json) => Salon(
    name: json['name'],
    city: json['city'],
    picture: json['picture'],
    id: json['_id'],
    role: json['role'],

  );
}