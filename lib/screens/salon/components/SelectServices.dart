import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    ServiceModel("service 1 ", false),
    ServiceModel("service 2 ", false),
    ServiceModel("service 3 ", false),
    ServiceModel("service 4 ", false),

  ];

  List<ServiceModel> selectedService = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Services"),
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
                  height:500,
                   color: Colors.grey.withOpacity(0.1),
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                  Expanded(
                    child: Container(
                      //    height: 300,
                      //   color: Colors.green,
                      child: ListView.separated(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        scrollDirection: Axis.vertical,
                        itemCount: sec.length,
                        separatorBuilder: (context, _) => SizedBox(height: 14),
                        itemBuilder: (context,index) => buildCard(sec: sec[index]),
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
          return ServiceItem(service[index].serviceName,
              service[index].isSelected, index);
            }),
           ),
            ),
      ],
    ),
  );

  Widget ServiceItem(String name, bool isSelected , int index){
    return ListTile(

      title: Text(name,style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),),
      trailing: isSelected
          ? Icon(Icons.check_circle,color: Colors.purple)
          : Icon(Icons.check_circle_outline_outlined,color: Colors.grey),
      onTap: (){
       setState(() {
         service[index].isSelected = !service[index].isSelected;
         if(service[index].isSelected == true) {
           selectedService.add(ServiceModel(name, true));
         }
         else if (service[index].isSelected == false){
           selectedService.removeWhere((element) =>
           element.serviceName == service[index].serviceName);
         }
        });
      },
    );
  }
}

class ServiceModel{
  String serviceName;
  bool isSelected;

  ServiceModel(this.serviceName, this.isSelected);

}

