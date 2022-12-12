import 'package:flutter/material.dart';
import '../../constants.dart';
import 'Salon.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'SalonPage.dart';
import 'package:purple/global.dart' as global;

class AllSalonPage extends StatefulWidget {
  AllSalonPage({Key? key}) : super(key: key);

  @override
  State<AllSalonPage> createState() => _AllSalonPageState();
}

class _AllSalonPageState extends State<AllSalonPage> {
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
        saloon.removeWhere((data) => data.role == 4);

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
        // automaticallyImplyLeading: false,
        title: const Text('All Salons'),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Container(
        //       width: (MediaQuery.of(context).size.width) * 0.45,
        //       height: 50,
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(15),
        //       ),
        //       child: TextField(
        //         onChanged:(value) {
        //           // search code
        //         },
        //         decoration: InputDecoration(
        //           enabledBorder: InputBorder.none,
        //           focusedBorder: InputBorder.none,
        //           hintText:
        //           'Srarch',
        //           prefixIcon: Icon(Icons.search,
        //             color: Colors.purple,),
        //           contentPadding: EdgeInsets.symmetric(
        //             horizontal: 12,
        //             vertical: 12,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ],

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
            // color: Colors.purple.withOpacity(0.15),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(saloon.picture, height: 130,width: 500,fit: BoxFit.cover,),
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

  const Saloon( {
    required this.name,
    required this.picture,
    required this.id,
    required this.role,

  }  );


  static Saloon fromJson(json) => Saloon(

    name: json['name'],
    picture: json['picture'],
    id: json['_id'],
    role: json['role'],

  );
}