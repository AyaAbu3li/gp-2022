import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'SalonPage.dart';

class AllSalonPage extends StatefulWidget {
  AllSalonPage({Key? key}) : super(key: key);
  @override
  State<AllSalonPage> createState() => _AllSalonPageState();
}
class _AllSalonPageState extends State<AllSalonPage> {
  List<Saloon> saloon = [];
  List<Saloon> saloonS = [];
  final controller = TextEditingController() ;

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
        this.saloonS = data.map<Saloon>(Saloon.fromJson).toList();
        saloonS.removeWhere((data) => data.role == 4);

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
        automaticallyImplyLeading: false,
        title: const Text('All Salons'),
        centerTitle: true,
      ),
      body:circular
          ? Center(child: CircularProgressIndicator())
          : Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(10),),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width) * 0.892,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: controller,
                        onChanged:(value) {
                          // search code
                          filterSearchResults(value);
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
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
               padding: const EdgeInsets.all(15.0),
                child:
                Container(
                  child: buildSalons(saloonS),
        ),
      ),
            ],
          ),
    );
  }

  void filterSearchResults(String query) {
    List<Saloon> dummySearchList = [];
    dummySearchList.addAll(saloon);
    if(query.isNotEmpty) {
      List<Saloon> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        saloonS.clear();
        saloonS.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        saloonS.clear();
        saloonS.addAll(saloon);
      });
    }
  }


  Widget buildSalons(List<Saloon> saloons) => ListView.builder(
    itemCount: saloons.length,
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemBuilder: (context,index){
      final salooon = saloons[index];
      return Card(
        elevation: 40,
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SalonPage(salooon.id.toString())));
          },
          child: Container(
            height: 220,
            // color: Colors.purple.withOpacity(0.15),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(salooon.picture, height: 130,width: 500,fit: BoxFit.cover,),
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(salooon.name,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black))
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