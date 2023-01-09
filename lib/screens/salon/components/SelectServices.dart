import 'dart:collection';
import 'dart:convert';
import '../../../constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Model/category.dart';
import '../../../Model/salon.dart';
import '../salon_screen.dart';
import 'package:purple/global.dart' as global;

class services extends StatefulWidget {
  const services({Key? key}) : super(key: key);
  @override
  State<services> createState() => _servicesState();
}

class _servicesState extends State<services> {

  Salon salon = Salon('','','','','','','','','','','','');
  List<Category> cate = [];
  List<Servicee> serviceee = [];
  List<Servicee> serviceee2 = [];

  List<Servicee> serCate = [];
  Map<String, Servicee> type = new HashMap();

  bool circular = true;
  bool empty = false;



  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData() async {
    var res = await http.get(Uri.parse("http://"+ip+":3000/salon"),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        'Authorization': global.token
      },
    );
    var decoded = json.decode(res.body);

    setState(() {
      salon.email = decoded['email'];
    });
    var res3 = await http.get(Uri.parse("http://"+ip+":3000/category/"+salon.email),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    var cat;
    cat = json.decode(res3.body);

    setState(() {
      this.cate = cat.map<Category>(Category.fromJson).toList();
    });
    if(cate.isNotEmpty) {
      for (int x = 0; x < cate.length; x++) {
        var res4 = await http.get(
          Uri.parse("http://" + ip + ":3000/services/" + salon.email),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
          },
        );
        var ser = json.decode(res4.body);
        setState(() {
          this.serviceee = ser.map<Servicee>(Servicee.fromJson).toList();
          this.serviceee2 = ser.map<Servicee>(Servicee.fromJson).toList();
        });
        this.serCate = serviceee2;
        serCate.removeWhere((data) => data.category != cate[x].category);

        for (int j = 0; j < serCate.length; j++) {
          _map.putIfAbsent(cate[x], () => <Servicee>[]).add(serCate[j]);
        }
      }
    } else {
      setState(() {
        empty = true;
      });
    }
    circular = false;
  }
  Map<Category,List<Servicee>> _map = Map();

  List<Servicee> selectedService = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Services"),
        centerTitle: true,
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : empty
          ? Center(child: Text("You have no Services",
          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black)))
          :
      SafeArea(
        child:SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Container(
                      width: (MediaQuery.of(context).size.width)* 0.85 ,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade300.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged:(value) {
                          // search code
                        },
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText:
                          'Srarch Services',
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height:500,
                   color: Colors.grey.withOpacity(0.1),
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                  Expanded(
                    child: Container(
                      child: ListView.separated(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        scrollDirection: Axis.vertical,
                        itemCount: cate.length,
                        separatorBuilder: (context, _) => SizedBox(height: 14),
                        itemBuilder: (context,index) => buildCard(sec: cate[index]),
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),

              ElevatedButton(
                onPressed: (){

                },
                child: Text("NEXT", style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 5,
                  color: Colors.white,
                ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple.shade600,
                  padding: EdgeInsets.symmetric(horizontal: 150,vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildCard({
    required Category sec,
  }) => Container(
    width: double.infinity,
    color: Colors.white,
    height: 200,

    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0,top: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              sec.category,
              style:
              TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87.withOpacity(0.5)),
            ),
          ),
        ),

       Expanded(
         child: Container(
          child: ListView.builder(
          itemCount: _map[sec]!.length,
            itemBuilder: (BuildContext context , int index)=>
                ServiceItem(serv: _map[sec]![index]),
          ),
         ),
       ),
      ],
    ),
  );

  Widget ServiceItem({required Servicee serv}){
    return ListTile(

      title: Text(
          serv.name,
        style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18)
      ),
        trailing: serv.isSelected

    ? Icon(Icons.check_circle,color: Colors.purple)
          : Icon(Icons.check_circle_outline_outlined,color: Colors.grey),
      onTap: (){
       setState(() {
         serv.isSelected = !serv.isSelected;
         if(serv.isSelected == true) {
           selectedService.add(serv);
         }
         else if (serv.isSelected == false){
           selectedService.removeWhere((element) =>
           element.id == serv.id);
         }
         print(selectedService);
        });
      },
    );
  }
}

class Servicee {
  final String name;
  final String price;
  final String category;
  final String id;
   bool isSelected;


  Servicee({
    required this.name,
    required this.price,
    required this.category,
    required this.id,
    required this.isSelected,

  });
  static Servicee fromJson(json) => Servicee(
    name: json['name'],
    price: json['price'].toString(),
    category: json['category'],
    id: json['_id'],
    isSelected: json['isSelected'],

  );
}

