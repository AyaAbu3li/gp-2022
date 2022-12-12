import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Feedbackk.dart';
import 'ServicePage.dart';

class SalonPage extends StatefulWidget {
  final String text;
  const SalonPage(this.text);
  @override
  State<SalonPage> createState() => _SalonPageState();
}
class _SalonPageState extends State<SalonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
     body: SafeArea(
       child:SingleChildScrollView(
         child: Column(
           children: [
             AppBarr(),
             SizedBox(height: 20),
             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 8.0),
                   child: Text("Our Team :",
                     style: TextStyle(color: Colors.purple.shade900,fontSize: 30,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,),
                 )),
             SizedBox(height: 8,),
             Bodyy(),
             SizedBox(height: 24,),
             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 8.0),
                   child: Text(
                     "Service we provide:",
                     style: TextStyle(color: Colors.purple.shade900,fontSize: 30,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,),
                 )),
             SizedBox(height: 8,),
             Bodyy2(),
             SizedBox(height: 24,),
             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 8.0),
                   child: Text(
                     "About Salon:",
                     style: TextStyle(color: Colors.purple.shade900,fontSize:30,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,),
                 )),
             SizedBox(height: 8,),
             Align(
           alignment: Alignment.centerLeft,
           child: Padding(
             padding: const EdgeInsets.only(left: 8.0),
             child: Row(
               children: [
                 Icon(Icons.description,size: 30,color: Colors.purple.shade900,),
                 Text(
                   " Description:",
                   style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,),
               ],
             ),

           )),
       //      SizedBox(height: 4,),
             Align(
           alignment: Alignment.centerLeft,
           child: Padding(
             padding: const EdgeInsets.only(left: 45.0),
             child: Text(
               "description",
               style: TextStyle(fontSize: 22,),textAlign: TextAlign.left,),
           )),
            SizedBox(height: 20,),

             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 8.0),
                   child: Row(
                     children: [
                       Icon(Icons.phone,size: 30,color: Colors.purple.shade900,),
                       Text(
                         " Phone Number:",
                         style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,),
                     ],
                   ),
                 )),
             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 45.0),
                   child: Text(
                     "0598989898",
                     style: TextStyle(fontSize: 22,),textAlign: TextAlign.left,),
                 )),
             SizedBox(height: 20,),

             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 8.0),
                   child: Row(
                     children: [
                       Icon(Icons.location_city,size: 30,color: Colors.purple.shade900,),
                       Text(
                         " City:",
                         style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,),
                     ],
                   ),
                 )),
             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 45.0),
                   child: Text(
                     "Nablus",
                     style: TextStyle(fontSize: 22,),textAlign: TextAlign.left,),
                 )),
             SizedBox(height: 20,),

             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 8.0),
                   child: Row(
                     children: [
                       Icon(Icons.find_replace,size: 30,color: Colors.purple.shade900,),
                       Text(
                         " Address:",
                         style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,),
                     ],
                   ),
                 )),
             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 45.0),
                   child: Text(
                     "Nablus-Palestine",
                     style: TextStyle(fontSize: 22,),textAlign: TextAlign.left,),
                 )),
             SizedBox(height: 20,),

             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 8.0),
                   child: Row(
                     children: [
                       Icon(Icons.facebook,size: 30,color: Colors.purple.shade900,),
                       Text(

                         " Facebook Link:",
                         style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,),
                     ],
                   ),

                 )),
             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 45.0),
                   child: Text(

                     "www.facebok...",
                     style: TextStyle(fontSize: 22,),textAlign: TextAlign.left,),

                 )),
             SizedBox(height: 20,),

             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 8.0),
                   child: Row(
                     children: [
                       Icon(Icons.snapchat_outlined,size: 30,color: Colors.purple.shade900,),
                       Text(

                         " Snapchat Link:",
                         style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,),
                     ],
                   ),

                 )),
             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 45.0),
                   child: Text(

                     "www.snapchat...",
                     style: TextStyle(fontSize: 22,),textAlign: TextAlign.left,),

                 )),
             SizedBox(height: 20,),

             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 8.0),
                   child: Row(
                     children: [
                       Icon(Icons.location_on,size: 30,color: Colors.purple.shade900,),
                       Text(

                         " Google Map Link:",
                         style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,),
                     ],
                   ),

                 )),
             Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 45.0),
                   child: Text(

                     "www.google...",
                     style: TextStyle(fontSize: 22,),textAlign: TextAlign.left,),

                 )),
             SizedBox(height: 30,),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Align( alignment: Alignment.centerLeft,
                child: Text("Write your feedback !"
                  ,style: TextStyle(color: Colors.purple.shade900,fontSize: 30,),)),
          ),
            // SizedBox(height: 13,),
          Padding(
              padding: EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 4,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
               hintText: "Enter your text here ",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),


            ),
          ),


             SizedBox(height: 10,),

             ElevatedButton(
               onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => Feedbackk()));
               },
               child: Text("See others feedback >", style: TextStyle(
                 fontSize: 20,
                 letterSpacing: 2,
                 color: Colors.white,
               ),),
               style: ElevatedButton.styleFrom(
                 primary: Colors.purple.shade900,
                 padding: EdgeInsets.symmetric(horizontal: 50),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
               ),
             ),
             SizedBox(height: 40,),


          //   value: SystemUiOverlayStyle.light,
           ],
         ),
       ),
     ),




    );

  }

  double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = 500;

    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }
}

class AppBarr extends StatelessWidget{
   const AppBarr({Key? key}) : super(key:key);
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 15, left: 16,right: 20),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xffb116dc),
            Color(0xff8778ce),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(50),
                child: Stack(
                  children: [
                    Container(
                      //   padding: EdgeInsets.all(getProportionateScreenWidth(1)),
                      height: 36,
                      width:36,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        // shape: BoxShape.circle,
                      ),
                      child:   Align(
                          alignment: Alignment.topLeft,
                          child:
                          Icon(Icons.arrow_back_outlined,size: 36,color: Colors.white,)),

                    ),
                  ],
                ),
              ),
            ],
          ),



          Align(
              alignment: Alignment.centerLeft,
              child: Text("\nWelcome to our salon",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,) ,)),

          const SizedBox(height: 20,),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
                size: 26,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: "Search ",
              labelStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              isDense: true,
            ),
          ),
        ],
      ),


    );
  }

}


class Employee{
  final String urlImage;
  final String name;
  final String job;
  
  const Employee({
  required this.urlImage, 
  required this.name,
    required this.job,
  });
}

class Service {
  final String urlImage;
  final String name;
  final String description;

  Service({
    required this.urlImage,
    required this.name,
    required this.description,
  });

}

class Bodyy extends StatelessWidget {
  List<Employee> employees = [
    Employee(
      urlImage:
      'assets/images/emp.png',
      name: 'Mary Ali',
      job: 'Salon Admin',
    ),

    Employee(
      urlImage:
      'assets/images/emp3.png',
      name: 'Yara Ahmad',
      job: 'Hair stylish',
    ),

    Employee(
      urlImage:
      'assets/images/emp.png',
      name: 'Aya Abu Ali',
      job: 'Hair stylish',
    ),

    Employee(
      urlImage:
      'assets/images/emp3.png',
      name: 'Aya Abu Ali',
      job: 'Hair stylish',
    ),

    Employee(
      urlImage:
      'assets/images/emp.png',
      name: 'Aya Abu Ali',
      job: 'Hair stylish',
    ),




  ];
   Bodyy({Key? key}) : super(key: key);

  

  @override
  
  Widget build(BuildContext context) {
   return


   Container(
     height: 130,
     child: ListView.separated(
       padding: EdgeInsets.all(6),
        scrollDirection: Axis.horizontal,
         itemCount: employees.length,
       separatorBuilder: (context, _) => SizedBox(width: 18,),
       itemBuilder: (context,index) => buildCard(employees: employees[index]),

     ),
   );

  }

  Widget buildCard({
  required Employee employees,
}) => Container(
    width: 113,
   
    child: Column(
      children: [
        Expanded(
          child:  AspectRatio(
            aspectRatio: 4/3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                employees.urlImage,
                fit: BoxFit.cover,
              ),
            ),
            
          ),),

        const SizedBox(height: 4,),
        Text(
          employees.name,
          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),
        ),
        const SizedBox(height: 4,),
        Text(
          employees.job,
          style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,),
        ),

      ],

    ),
  );

}

class Bodyy2 extends StatelessWidget {
  List<Service> services = [
    Service(
      urlImage:
      'assets/images/hair.png',
      name: 'Hair Cut',
      description: 'All hair cuts available',
    ),

    Service(
      urlImage:
      'assets/images/makeu.png',
      name: 'Make up',
      description: 'Different looks',
    ),

    Service(
      urlImage:
      'assets/images/makeu.png',
      name: 'Make up',
      description: 'Different looks',
    ),

    Service(
      urlImage:
      'assets/images/makeu.png',
      name: 'Make up',
      description: 'Different looks',
    ),






  ];
  Bodyy2({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
 //   final Service s ;
    return
      Container(
        height: 230,
        child: ListView.separated(
          padding: EdgeInsets.all(6),
          scrollDirection: Axis.horizontal,
          itemCount: services.length,
          separatorBuilder: (context, _) => SizedBox(width: 35,),
          itemBuilder: (context,index) => buildCard(context, services: services[index]),

        ),
      );
  }

  Widget buildCard(
      BuildContext context,{
    required Service services,
  }) => Container(
    width: 180,

    child: Column(
      children: [
        Expanded(
          child:  AspectRatio(
            aspectRatio: 4/3,
            child:  GestureDetector(
             onTap: (){
             print("Container clicked");
             Navigator.push(context, MaterialPageRoute(builder: (context) => ServicePage(services: services)));
               },
            child: Container(

              //padding: EdgeInsets.all(getProportionateScreenWidth(5)),
            decoration: BoxDecoration(
             color: Colors.grey.withOpacity(0.1),
             borderRadius: BorderRadius.circular(15),
             ),
            child: Image.asset(services.urlImage,fit: BoxFit.cover,),
             ),
               ),

          ),
        ),

        const SizedBox(height: 4,),
        Text(
          services.name,
          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,),
        ),
        const SizedBox(height: 4,),
        Text(
          services.description,
          style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,),
        ),

      ],

    ),
  );

}


class  Info {
  final String name;
  final String value;



  const Info( {
    required this.name,
    required this.value,

  }  );

  static Info fromJson(json) => Info(
    name: json['name'],
    value: json['value'],

  );
}