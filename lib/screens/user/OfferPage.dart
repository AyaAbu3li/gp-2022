import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../Model/Offer.dart';

class OfferPage extends StatefulWidget {
  final String text;
  const OfferPage(this.text);
  @override
  State<OfferPage> createState() => _OfferPageRequestState();
}
class _OfferPageRequestState extends State<OfferPage> {

  List<Service> service = [];

  Offer offer = Offer('','','','','','','','','');
  bool circular = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData() async {

    var res = await http.get(Uri.parse("http://"+ip+":3000/offer/"+widget.text),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    setState(() {
      var decoded = json.decode(res.body);
      offer.picture = decoded['picture'];
      offer.price = decoded['price'].toString();
      offer.name = decoded['name'];
      offer.Salon = decoded['salonname'];
      offer.id = decoded['_id'];
      offer.enddate = decoded['enddate'];
      offer.startdate = decoded['startdate'];
    });
    var res2 = await http.get(Uri.parse("http://"+ip+":3000/offerservices/"+offer.id),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        });
    var data = json.decode(res2.body);
    setState(() {
      this.service = data.map<Service>(Service.fromJson).toList();
      service.removeWhere((data) => data.owner != offer.id);
      circular = false;
    });

  }
  void Book() async {
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(offer.name + " offer"),
      ),
      body: circular
      ? Center(child: CircularProgressIndicator())
      : Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(offer.picture,height: 150,width:300,fit: BoxFit.cover,),
          const SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Align(
              child: Text("The offer available in "+
                  offer.Salon,
                style: TextStyle(fontSize: 22,),
              ),
            ),
          ),
          const SizedBox(height: 1,),
          Card(
            elevation: 10,
            child: Container(
              height: getProportionateScreenHeight(400),
              width: getProportionateScreenWidth(350),
              color: Colors.purple.withOpacity(0.20),
              child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "₪"
                            + offer.price
                        ,
                        style: TextStyle(fontSize: 26,),
                      ),
                    ),
                    const Divider(color: Colors.black54),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Services",
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.purple),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: getProportionateScreenHeight(235),
                        child:
                      Padding(
                          padding: const EdgeInsets.only(left: 30.0, right: 30),
                          child:
                        Column(
                          children: [
                            ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: service.length,
                              separatorBuilder: (context, _) => SizedBox(height: 10),
                              itemBuilder: (BuildContext context, int index) =>
                                  ServiceItem2(serv: service[index]),
                            ),
                          ],
                        ),
                      ),
                   ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "From "+offer.startdate+" to "+offer.enddate,
                        style: TextStyle(fontSize: 20 ,color: Colors.purple),
                      ),
                    ),
                  ]
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(300),
                child:
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    Book();
                  },
                  child: Text("Book Appointment",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(20),
                      color: Colors.white,),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget ServiceItem2({required Service serv}){
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            color: Colors.white,
        ),
          // height: 35.0,
          child:
          Text(serv.name,
            style:
            TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black.withOpacity(0.70)
            )
          ),
      )
        ],
    );
  }
}

class Service {
  final String name;
  final String id;
  final String owner;

  const Service( {
    required this.name,
    required this.id,
    required this.owner,

  }  );


  static Service fromJson(json) => Service(
    name: json['service'],
    id: json['_id'],
    owner: json['owner'],

  );
}

