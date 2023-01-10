import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../Model/category.dart';
import '../../../Model/salon.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;

import '../../size_config.dart';


class BookingScreen extends StatefulWidget {
  final String text;
  const BookingScreen(this.text);
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {


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

    var res3 = await http.get(Uri.parse("http://"+ip+":3000/category/"+widget.text),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    var cat;
    cat = json.decode(res3.body);

    setState(() {
      this.cate = cat.map<Category>(Category.fromJson).toList();
    });

    for (int x = 0; x < cate.length; x++) {
      var res4 = await http.get(
        Uri.parse("http://" + ip + ":3000/services/" + widget.text),
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

    circular = false;
  }
  Map<Category,List<Servicee>> _map = Map();

  List<Servicee> selectedService = [];



  void makeBooking() async {
    try{
      // var res = await http.post(Uri.parse("http://"+ip+":3000/offers"),
      //     headers: <String, String>{
      //       'Context-Type': 'application/json;charSet=UTF-8',
      //       'Authorization': global.token
      //     },
      //     body: <String, String>{
      //       'name': offer.name,
      //       'startdate': offer.startdate,
      //       'enddate': offer.enddate,
      //       'price': offer.price
      //     });
      // var decoded = json.decode(res.body);
      //
      // setState(() {
      //   offer.id = decoded['_id'];
      // });

      // for(int x = 0 ; x < selectedService.length ; x++) {
      //   var res2 = await http.post(
      //       Uri.parse("http://" + ip + ":3000/offerservice"),
      //       headers: <String, String>{
      //         'Context-Type': 'application/json;charSet=UTF-8',
      //         'Authorization': global.token
      //       },
      //       body: <String, String>{
      //         'service': selectedService[x].name,
      //         'owner': offer.id
      //       });
      // }

      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Added'),
              content: Text("Offer has been successfully added"),
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
                  onPressed: () =>
                      Navigator.pop(context),
                ),
              ],
            ),
      );


    } catch(e){
      print("Make booking");
      print(e);
    }
  }




  int currentStep = 0;
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState(() {
      today = day;
    });
  }
  List<String> items = [
    "09:00 AM",
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "12:00 PM",
    "12:30 PM",
    "01:00 PM",
    "01:30 PM",
    "02:00 PM",
    "02:30 PM",
    "03:00 PM",
    "03:30 PM",
    "04:00 PM",
    "04:30 PM",
    "05:00 PM",
    "05:30 PM",
    "06:00 PM",

  ];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Make a Reservation"),
          centerTitle: true,
        ),
        body:circular
        ? Center(child: CircularProgressIndicator())
        : Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.purple),
          ),
          child: Stepper(
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            onStepContinue: (){
              final isLastStep = currentStep == getSteps().length -1;
              if(isLastStep){
                print('Completed');
                // send data to server
              }
              else{
                setState( () => currentStep += 1);
              }

            },
            onStepTapped: (step) => setState( () => currentStep = step),
            onStepCancel:
                currentStep == 0 ? null : () => setState(() => currentStep -= 1),
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

  List<Step> getSteps() =>[
    Step( state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,title: Text('Services'),
      content: SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Services",
                    style: TextStyle(
                      color: Colors.purple.shade900,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left)
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      "Select your needs",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 19),
                      textAlign: TextAlign.left),
                  )
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: (MediaQuery.of(context).size.width) * 0.9,
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
          SizedBox(height: 10),
          Container(
            height:480,
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
        ],
      ),
    ),
    ),
    Step(state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,title: Text('Book a spot'), content: SingleChildScrollView(
      child: Column(
        children: [
          Text("Select the appropriate day ", style: TextStyle(fontSize: 22,color: Colors.purple),),
          Container(
            child: TableCalendar(
              rowHeight: 45,
              headerStyle: HeaderStyle(formatButtonVisible: false,titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, today),
              focusedDay: today,
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030,3,14),
              onDaySelected: _onDaySelected,
            ),
          ),
          SizedBox(height: 15),
          Text("Select the appropriate Time ",
            style: TextStyle(
                fontSize: 22,
                color: Colors.purple)
          ),
          SizedBox(height: 15),
          Container(
            height: 70,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: items.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx,index){
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  current= index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.all(4),
                                width: 100,
                                height: 45,
                                decoration: BoxDecoration(
                                    borderRadius : BorderRadius.circular(10),
                                    color: current == index
                                        ? Colors.purple.withOpacity(0.3)
                                        : Colors.white,
                                    border: current == index
                                        ?Border.all(
                                        color: Colors.purple,width: 2)
                                        : Border.all(
                                        color: Colors.grey,width: 2)
                                ),
                                child: Center(
                                  child: Text(
                                    items[index],
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                      color: current== index
                                          ? Colors.purple.shade900
                                          : Colors.grey,
                                      fontSize:  current== index
                                          ? 15
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
          Text("Selected Day = " + today.toString().split(" ")[0],
            style: TextStyle(fontSize:18,color: Colors.black)),
          Text("Selected Time = " + items[current],
            style: TextStyle(fontSize: 18,color: Colors.black)),
          SizedBox( height: 10),
        ],
      ),
    ),
    ),
    Step(isActive: currentStep >= 2,title: Text('Checkout'), content: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0,right: 0),
            child: Container(

              color: Colors.purple.withOpacity(0.04),
              height: 550,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 7,),
                  Text("Salon Name", style: TextStyle(fontSize: 26,
                      fontWeight: FontWeight.bold, color: Colors.purple),),
                  SizedBox(height: 8,),
                  Text("THANK YOU FOR BOOKING OUR SERVICES!", style: TextStyle(fontSize: 17,
                      fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.8)),),
                  SizedBox(height: 8,),
                  Text("BOOKING INFORMATION", style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w800),),
                  SizedBox(height: 32,),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 16,),
                        Text("User name ",style: TextStyle(fontSize: 17),)
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 16,),
                        Text("Reservation Date :",style: TextStyle(fontSize: 17),),
                        SizedBox(width: 16,),
                        Text("17-5-2022",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: [
                        Icon(Icons.timelapse),
                        SizedBox(width: 16,),
                        Text("Reservation Time :",style: TextStyle(fontSize: 17),),
                        SizedBox(width: 16,),
                        Text("10:00 PM",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Divider(
                    color: Colors.black54,
                    indent: 0,
                    endIndent: 0,
                  ),
                  SizedBox(height: 10,),
                  Text("SERVICES BOOKED",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0,right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Service name",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w800,color: Colors.black.withOpacity(0.70)),),
                        SizedBox(width: 16,),
                        Text("#30",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue.shade900),),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0,right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Service 2",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w800,color: Colors.black.withOpacity(0.70)),),
                        SizedBox(width: 16,),
                        Text("#30",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue.shade900),),

                      ],
                    ),
                  ),
                  SizedBox(height: 40,),
                  Divider(
                    color: Colors.black54,
                    indent: 0,
                    endIndent: 0,
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0,right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TOTAL PRICE",style: TextStyle(fontSize: 22,color: Colors.black),),
                        SizedBox(width: 16,),
                        Text("#30",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,color: Colors.blue.shade900),),

                      ],
                    ),
                  ),





                ],
              ),



            ),
          ),
          SizedBox(height: 10,),










          //   value: SystemUiOverlayStyle.light,
        ],
      ),
    ),),

  ];
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




