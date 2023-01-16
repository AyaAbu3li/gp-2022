import 'package:flutter/material.dart';
import 'Salon.dart';
import 'SalonPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart';
import 'package:purple/global.dart' as global;


class NewSalonsPage extends StatefulWidget {
  const NewSalonsPage({Key? key}) : super(key: key);
  @override
  State<NewSalonsPage> createState() => _NewSalonsPageState();
}

class _NewSalonsPageState extends State<NewSalonsPage> {

  List<Saloon> saloon = [];
  bool circular = true;

  @override
  void initState() {
    super.initState();
    getSalons();
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
        this.saloon = data.map<Saloon>(Saloon.fromJson).toList();
        saloon.removeWhere((data) => data.city != global.city);
        circular = false;
      });
    } catch(e){
      print("hiiii");
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salons in '+global.city),
      ),
      body:circular
          ? Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              child: buildSalons(saloon),
        ),
      ),
    );
  }

  Widget buildSalons(List<Saloon> saloons) => ListView.builder(
    itemCount: saloons.length,
    itemBuilder: (context,index){
      final saloon = saloons[index];
      return Card(
        elevation: 40,
        child: GestureDetector(
          onTap: (){
            print("Container clicked");
            Navigator.push(context, MaterialPageRoute(builder: (context) => SalonPage(saloon.id.toString())));
          },
          child: Container(
            height: 220,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.network(saloon.picture, height: 130,width: 500,fit: BoxFit.cover,),
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(saloon.name,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black))
                ),
              ],
            ),
          ),
        ),
      );

    },
  );
}

class Saloon {
  final String name;
  final String picture;
  final String id;
  final int role;
  final String city;

  const Saloon( {
    required this.name,
    required this.picture,
    required this.id,
    required this.role,
    required this.city,

  }  );


  static Saloon fromJson(json) => Saloon(

    name: json['name'],
    picture: json['picture'],
    id: json['_id'],
    role: json['role'],
    city: json['city'],

  );
}