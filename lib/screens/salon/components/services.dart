// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:purple/size_config.dart';
// import 'package:http/http.dart' as http;
// import 'package:purple/Model/Serv.dart';
// import 'package:purple/Model/category.dart';
// import 'editService.dart';
// import '../../../Model/salon.dart';
// import '../../../constants.dart';
//
// class services extends StatefulWidget {
//   const services({Key? key}) : super(key: key);
//
//   @override
//   State<services> createState() => _servicesState();
// }
//
// class _servicesState extends State<services> {
//   Salon salon = Salon('','','','','','','','','','','','');
//   List<Category> cate = [];
//   List<Servicee> serviceee = [];
//   List<Servicee> serviceeCategory = [];
//   bool serviceempty = false;
//   bool empEmpty = false;
//   double num = 0;
//   bool circular = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   void fetchData() async {
//     var data2;
//     var cat;
//     var ser;
//     var rat;
//     try{
//       var res = await http.get(Uri.parse("http://"+ip+":3000/salons/"+widget.text),
//         headers: <String, String>{
//           'Context-Type': 'application/json;charSet=UTF-8',
//         },
//       );
//       setState(() {
//         var decoded = json.decode(res.body);
//         salon.name = decoded['name'];
//         salon.email = decoded['email'];
//         salon.picture = decoded['picture'];
//         salon.city = decoded['city'];
//         salon.phone = decoded['phone'].toString();
//         salon.closeTime = decoded['closeTime'];
//         salon.holiday = decoded['holiday'];
//         salon.openTime = decoded['openTime'];
//         salon.address = decoded['address'];
//         salon.googlemaps = decoded['googlemaps'];
//       });
//
//       var res2 = await http.get(Uri.parse("http://"+ip+":3000/employee/"+salon.name),
//         headers: <String, String>{
//           'Context-Type': 'application/json;charSet=UTF-8',
//         },
//       );
//       data2 = json.decode(res2.body);
//       setState(() {
//         this.employees = data2.map<Employee>(Employee.fromJson).toList();
//         if(employees.isEmpty){
//           empEmpty = true;
//         }
//
//       });
//
//       var res3 = await http.get(Uri.parse("http://"+ip+":3000/category/"+salon.email),
//         headers: <String, String>{
//           'Context-Type': 'application/json;charSet=UTF-8',
//         },
//       );
//       cat = json.decode(res3.body);
//
//       setState(() {
//         this.cate = cat.map<Category>(Category.fromJson).toList();
//         currentCategory = cate[0].category;
//       });
//
//       var res4 = await http.get(Uri.parse("http://"+ip+":3000/services/"+salon.email),
//         headers: <String, String>{
//           'Context-Type': 'application/json;charSet=UTF-8',
//         },
//       );
//       ser = json.decode(res4.body);
//       setState(() {
//         this.serviceee = ser.map<Servicee>(Servicee.fromJson).toList();
//         this.serviceeCategory = ser.map<Servicee>(Servicee.fromJson).toList();
//         serviceeCategory.removeWhere((data) => data.category != currentCategory);
//         if(serviceee.isEmpty){
//           serviceempty = true;
//         }
//       });
//
//       var res5 = await http.get(Uri.parse("http://"+ip+":3000/rating/"+salon.email),
//         headers: <String, String>{
//           'Context-Type': 'application/json;charSet=UTF-8',
//         },
//       );
//       rat = json.decode(res5.body);
//       setState(() {
//         this.RatingS = rat.map<Rating>(Rating.fromJson).toList();
//         if(RatingS.isEmpty){
//           num = 0;
//           return;
//         }
//
//         for(int i=0; i<RatingS.length; i++){
//           items.add(RatingS[i].rating);
//         }
//         num = items.reduce(max);
//
//       });
//
//       circular = false;
//
//     } catch(e){
//       print(" hiiii");
//       print(e);
//     }
//   }
//
//
//   List<ServiceModel> service = [
//     ServiceModel("service 1 ", "15"),
//     ServiceModel("service 2 ", "15"),
//     ServiceModel("service 3 ", "15"),
//     ServiceModel("service 4 ", "15"),
//
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Services"),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child:SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 15),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30.0),
//                     child: Container(
//                       width: (MediaQuery.of(context).size.width)* 0.85 ,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.purple.shade300.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: TextField(
//                         onChanged:(value) {
//                           // search code
//                         },
//                         decoration: InputDecoration(
//                           enabledBorder: InputBorder.none,
//                           focusedBorder: InputBorder.none,
//                           hintText:
//                           'Srarch Services',
//
//                           prefixIcon: Icon(Icons.search),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 10),
//
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Container(
//                   height:600,
//                    color: Colors.grey.withOpacity(0.1),
//                   width: double.infinity,
//                   child: Column(
//                     children: [
//                       SizedBox(height: 20),
//
//                   Expanded(
//                     child: Container(
//                       child: ListView.separated(
//                         padding: EdgeInsets.only(left: 10,right: 10),
//                         scrollDirection: Axis.vertical,
//                         itemCount: sec.length,
//                         separatorBuilder: (context, _) => SizedBox(height: 25),
//                         itemBuilder: (context,index) => buildCard(sec: sec[index]),
//                       ),
//                     ),
//                   ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 15),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Widget buildCard({
//     required String sec,
//   }) => Container(
//     width: double.infinity,
//     color: Colors.white,
//     height: 200,
//
//     child: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 10.0,top: 10),
//           child: Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               sec,
//               style:
//               TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87.withOpacity(0.5)),
//             ),
//           ),
//         ),
//
//        Expanded(
//          child: Container(
//           child: ListView.builder(
//           itemCount: service.length,
//           itemBuilder: (BuildContext context , int index){
//           return ServiceItem(service[index].serviceName, service[index].price,
//                index);
//             }),
//            ),
//             ),
//       ],
//     ),
//   );
//
//   Widget ServiceItem(String name , String price ,int index){
//     return ListTile(
//         leading: Text(
//             name,
//             style:
//             TextStyle(
//                 fontWeight: FontWeight.w800,
//                 fontSize: 20)
//         ),
//       title: Text("₪"+price,
//           style:
//           TextStyle(fontSize: 16)),
//       trailing: Icon(Icons.arrow_forward_rounded,color: Colors.purple),
//       onTap: (){
//
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => const editService('name')
//         )
//         );
//           },
//       );
//   }
// }
//
// class ServiceModel{
//   String serviceName;
//   String price;
//
//   ServiceModel(
//       this.serviceName,
//       this.price,
//       );
// }
//
