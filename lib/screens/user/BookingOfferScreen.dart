import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../Model/salon.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;
import '../../Model/Offer.dart';
import '../../Model/user.dart';
import '../../size_config.dart';
import 'makeOfferBooking.dart';


class BookingOfferScreen extends StatefulWidget {
  final String text;
  const BookingOfferScreen(this.text);
  @override
  State<BookingOfferScreen> createState() => _BookingOfferScreenState();
}

class _BookingOfferScreenState extends State<BookingOfferScreen> {
  int priceTotal=0;
  User user = User('','','','','','');
  Salon salon = Salon('','','','','','','','','','','','');
  late String salonEmail;
  bool circular = true;
  bool empty = false;
  int holiday=2;
  List<String> days = ["",
    "monday", "tuesday" , "wednesday",
    "thursday", "friday", "saturday", "sunday"
  ];
  Offer offer = Offer('','','','','','','','','');
  List<Service> service = [];



  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData() async {
    var res = await http.get(Uri.parse("http://"+ip+":3000/users/me"),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        'Authorization': global.token
      },
    );
    setState(() {
      var decoded = json.decode(res.body);
      user.name = decoded['name'];
      user.email = decoded['email'];
      user.picture = decoded['picture'];
      user.phone = decoded['phone'].toString();
    });


    var res2 = await http.get(Uri.parse("http://"+ip+":3000/offer/"+widget.text),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    setState(() {
      var decoded = json.decode(res2.body);
      offer.picture = decoded['picture'];
      offer.price = decoded['price'].toString();
      offer.name = decoded['name'];
      offer.Salon = decoded['salonname'];
      offer.id = decoded['_id'];
      this.salonEmail = decoded['salonEmail'];
      offer.enddate = decoded['enddate'];
      offer.startdate = decoded['startdate'];
    });

    var ress = await http.get(Uri.parse("http://"+ip+":3000/salonE/"+salonEmail),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    setState(() {
      var decoded = json.decode(ress.body);
      salon.name = decoded[0]['name'];
      salon.email = decoded[0]['email'];
      salon.picture = decoded[0]['picture'];
      salon.city = decoded[0]['city'];
      salon.phone = decoded[0]['phone'].toString();
      salon.closeTime = decoded[0]['closeTime'];
      salon.holiday = decoded[0]['holiday'].toLowerCase();
      salon.openTime = decoded[0]['openTime'];
      salon.address = decoded[0]['address'];
      salon.googlemaps = decoded[0]['googlemaps'];
    });

    for(int x = 1; x<days.length; x++){
      if(days[x]==salon.holiday){
        setState(() {
          holiday = x;
          print(x);
        });
        break;
      }
    }


    var res4 = await http.get(Uri.parse("http://"+ip+":3000/offerservices/"+offer.id),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        });
    var data = json.decode(res4.body);
    setState(() {
      this.service = data.map<Service>(Service.fromJson).toList();
      service.removeWhere((data) => data.owner != offer.id);
    });

    for(
    int i = int.parse(salon.openTime.split(":")[0]) ;
    i <= 12;
    i++){
      if(i == 11){
        items.add(i.toString()+":00 AM");
      } else if(i == 12){
        items.add(i.toString()+":00 PM");
      } else {
        items.add("0" + i.toString() + ":00 AM");
      }
    }
    for(
    int i = 1 ;
    i < int.parse(salon.closeTime.split(":")[0]);
    i++){
      items.add("0"+i.toString()+":00 PM");
    }

    circular = false;
  }


  int currentStep = 0;
  DateTime pre = DateTime.now();
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState(() {
      if(day.weekday == holiday){
      // pre = today;
      return;
      }
      today = day;
    });
  }
  List<String> items = [];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(service.isNotEmpty) {
          final shouldPop = await showWarning(context);
          return shouldPop ?? false;
        }
        return true;
      },
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
            controlsBuilder: (context,ControlsDetails details) {
              return Row(
                children: <Widget>[
                  SizedBox(
                    width: SizeConfig.screenWidth*0.4,
                    child:
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Previous',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                    ),
              ),
                SizedBox(width: SizeConfig.screenWidth*0.075),
                SizedBox(
                  width: SizeConfig.screenWidth*0.4,
                  child:
                  TextButton(
                    onPressed: details.onStepContinue,
                    child: const Text('Next',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                    ),
                  ),
               ),
                ],
              );
            },
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            onStepContinue: (){
              final isLastStep = currentStep == getSteps().length -1;
              if(isLastStep){
                print('Completed');
                // send data to server
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    DoneOfferBooking(salon.id,today,items[current],service,int.parse(offer.price))));
              }
              else{
                if(service.isEmpty) { setState(() => currentStep = currentStep);
                }else { setState(() => currentStep += 1); }
              }
            },
            onStepCancel:
                currentStep == 0 ? null : () => setState(() => currentStep -= 1),
        ),
      ),
      ),
    );
  }


  Widget ServiceItem2({required Service serv}){
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              color: Colors.white,
            ),
            // height: 35.0,
            child:
            Text(serv.name,
                style:
                TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withOpacity(0.70)
                )
            ),
          )
        ],
      );
  }

  Widget ServiceItem({required Service serv}){
    return ListTile(
        tileColor: Colors.grey.withOpacity(0.1) ,
       shape: RoundedRectangleBorder(
           borderRadius:
           BorderRadius.only(
               topRight: Radius.circular(32),
               bottomRight: Radius.circular(32)
           )
       ),
      title: Text(
            serv.name,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18)
        ),
      trailing: Icon(Icons.check_circle,color: Colors.purple),
      onTap: (){},
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
            ],
          ),
          SizedBox(height: 10),
          Container(
            height:400,
            // color: Colors.grey.withOpacity(0.1),
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: service.length,
                      separatorBuilder: (context, _) => SizedBox(height: 14),
                      itemBuilder: (context,index) => ServiceItem(serv: service[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    ),
    ),
    Step(state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,title: Text('Book a spot'),
      content:
     SingleChildScrollView(
       child: Column(
        children: [
          Text("Select the appropriate day ",
            style:
            TextStyle(
                fontSize: 22,
                color: Colors.purple),
          ),
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
              holidayPredicate: (day) {
                return day.weekday == holiday;
              },
              calendarStyle: CalendarStyle(
                holidayDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle
                ),
                holidayTextStyle: TextStyle(
                    color: Colors.white
                ),
                selectedDecoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    shape: BoxShape.circle
                ),
                todayDecoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                ),
                todayTextStyle: TextStyle(
                    color: Colors.black54
                ),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: SizeConfig.screenWidth * 0.2),
              Text("● ",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.redAccent)
              ),
              Text("Closed",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  )
              ),
              SizedBox(width: SizeConfig.screenWidth * 0.1),
              Text("● ",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.lime)
              ),
              Text("Full",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  )
              ),
            ],
          ),
          SizedBox(height: 5),
          Text("Select the appropriate Time",
            style: TextStyle(
                fontSize: 22,
                color: Colors.purple)
          ),
          SizedBox(height: 5),
          Container(
            height: 60,
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
    Step(isActive: currentStep >= 2,title: Text('Checkout'),
      content:
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Container(
                color: Colors.purple.withOpacity(0.04),
                height: 540,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Text(salon.name,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,

                      ),
                    ),
                    SizedBox(height: 5),
                    Text("Thank you for booking our services!",
                        style: TextStyle(
                            fontSize: 19,
                            // fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.8)
                        )
                    ),
                    SizedBox(height: 10),
                    Text("BOOKING INFORMATION",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 16,),
                          Text(user.name, style: TextStyle(fontSize: 17),)
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
                          Text("Reservation Date :",
                              style: TextStyle(fontSize: 17)
                          ),
                          SizedBox(width: 16),
                          Text(today.toString().split(" ")[0],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)
                          ),
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
                          Text("Reservation Time :", style: TextStyle(
                              fontSize: 17),),
                          SizedBox(width: 16,),
                          Text(items[current], style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),),

                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(
                      color: Colors.black54,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(height: 10),
                    Text("SERVICES BOOKED",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30),
                      child:
                      Column(
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: service.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ServiceItem2(serv: service[index]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.black54,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("TOTAL PRICE",
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.black),
                          ),
                          SizedBox(width: 16),
                          Text("₪${offer.price}",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),

    ),
  ];
}

  Future<bool?> showWarning(BuildContext context) async =>
      showDialog<bool>(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Hold on!'),
                content: Text("Are you sure want to go back?"),
                actions: [
                  TextButton(
                    child: Text('No',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          color: Colors.white,)),
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.pop(context,false),
                  ),
                  TextButton(
                    child: Text('Yes',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          color: Colors.white,)),
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.pop(context,true),
                  ),
                ],
          ),
      );

class Service {
  final String name;
  final String id;
  final String owner;

  const Service( {
    required this.name,
    required this.id,
    required this.owner,

  }  );


  static Service fromJson(json) => Service(
    name: json['service'],
    id: json['_id'],
    owner: json['owner'],

  );
}





