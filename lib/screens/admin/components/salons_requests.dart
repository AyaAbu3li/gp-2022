import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:purple/screens/admin/admin_screen.dart';
import 'package:purple/screens/admin/components/salons_details_request.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'salons_details.dart';
import 'package:http/http.dart' as http;

class SalonsRequests extends StatefulWidget {
const SalonsRequests({Key? key}) : super(key: key);

@override
State<SalonsRequests> createState() => _SalonsRequestsState();
}
class _SalonsRequestsState extends State<SalonsRequests> {
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
        saloon.removeWhere((data) => data.role != 4);
        if(saloon.isEmpty){
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('come back later'),
                  content: Text("There are no salon requests at the moment"),
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
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Requests')),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => salonsdetailsRequest(saloon.id.toString())));
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
