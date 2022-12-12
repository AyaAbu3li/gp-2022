import 'package:flutter/material.dart';
import 'SalonPage.dart';

class ServicePage extends StatelessWidget {
  final Service services;
  const ServicePage({Key? key, required this.services}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(services.name + " Service"),

      ),
      body: Column(
        children: [
          SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 12.0),
            child: Align( alignment: Alignment.center,
                child: Image.asset(services.urlImage,height: 180,width:500,fit: BoxFit.cover,)),
          ),
          const SizedBox(height: 14,),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                services.name,
                style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: Colors.purple,),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                services.description,
                style: TextStyle(fontSize: 22,),
              ),
            ),
          ),

          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Book Service now !",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.purple),
              ),
            ),
          ),



        ],
      ),
    );
  }
}

