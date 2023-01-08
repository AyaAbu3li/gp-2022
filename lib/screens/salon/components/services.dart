import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purple/size_config.dart';

import 'editService.dart';

class services extends StatefulWidget {
  const services({Key? key}) : super(key: key);

  @override
  State<services> createState() => _servicesState();
}

class _servicesState extends State<services> {

  List<String> sec = [
    "MAKEUP",
    "HAIR",
    "FACE",
    "LASER",
    "NAILS",
    "SCIN CARE",
    "WEDDING",
  ];

  List<ServiceModel> service = [
    ServiceModel("service 1 ", "15"),
    ServiceModel("service 2 ", "15"),
    ServiceModel("service 3 ", "15"),
    ServiceModel("service 4 ", "15"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Services"),
        centerTitle: true,
      ),
      body: SafeArea(
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
                  height:600,
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
                        itemCount: sec.length,
                        separatorBuilder: (context, _) => SizedBox(height: 25),
                        itemBuilder: (context,index) => buildCard(sec: sec[index]),
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),

            ],
          ),
        ),
      ),
    );
  }
  Widget buildCard({
    required String sec,
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
              sec,
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
          itemCount: service.length,
          itemBuilder: (BuildContext context , int index){
          return ServiceItem(service[index].serviceName, service[index].price,
               index);
            }),
           ),
            ),
      ],
    ),
  );

  Widget ServiceItem(String name , String price ,int index){
    return ListTile(
        leading: Text(
            name,
            style:
            TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20)
        ),
      title: Text("₪"+price,
          style:
          TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_rounded,color: Colors.purple),
      onTap: (){

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const editService('name')
        )
        );
          },
      );
  }
}

class ServiceModel{
  String serviceName;
  String price;

  ServiceModel(
      this.serviceName,
      this.price,
      );
}

