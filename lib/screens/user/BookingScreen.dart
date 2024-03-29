import 'package:purple/screens/user/lastStep.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../Model/category.dart';
import '../../../Model/salon.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;
import '../../Model/user.dart';
import '../../size_config.dart';
import 'makeBooking.dart';

class BookingScreen extends StatefulWidget {
  final String text;
  const BookingScreen(this.text);
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int priceTotal=0;
  User user = User('','','','','','');
  Salon salon = Salon('','','','','','','','','','','','');
  List<Category> cate = [];
  List<Category> cateS = [];

  List<Servicee> serviceee = [];
  List<Servicee> serviceee2 = [];
  final controller = TextEditingController() ;

  List<Servicee> serCate = [];

  bool circular = true;
  bool empty = false;
  int holiday=2;
  List<String> days = ["",
    "monday", "tuesday" , "wednesday",
    "thursday", "friday", "saturday", "sunday"
  ];

  @override
  void initState() {
    super.initState();
    fetchData();

    _map2.clear();
    _map2.addAll(_map);
    cateS.clear();
    cateS.addAll(cate);
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

    var ress = await http.get(Uri.parse("http://"+ip+":3000/salons/"+widget.text),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    setState(() {
      var decoded = json.decode(ress.body);
      salon.name = decoded['name'];
      salon.email = decoded['email'];
      salon.picture = decoded['picture'];
      salon.city = decoded['city'];
      salon.phone = decoded['phone'].toString();
      salon.closeTime = decoded['closeTime'];
      salon.holiday = decoded['holiday'].toLowerCase();
      salon.openTime = decoded['openTime'];
      salon.address = decoded['address'];
      salon.googlemaps = decoded['googlemaps'];
    });

    for(int x = 1; x<days.length; x++){
      if(days[x]==salon.holiday){
        setState(() {
          holiday = x;
        });
        break;
      }
    }

    var res3 = await http.get(Uri.parse("http://"+ip+":3000/category/"+salon.email),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    var cat;
    cat = json.decode(res3.body);

    setState(() {
      this.cate = cat.map<Category>(Category.fromJson).toList();
      this.cateS = cat.map<Category>(Category.fromJson).toList();
    });

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
        _map2.putIfAbsent(cate[x], () => <Servicee>[]).add(serCate[j]);
      }
    }
    _map2.clear();
    _map2.addAll(_map);
    cateS.clear();
    cateS.addAll(cate);

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

  List<String> items = [];



  Map<Category,List<Servicee>> _map = Map();
  Map<Category,List<Servicee>> _map2 = Map();

  List<Servicee> selectedService = [];


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
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(selectedService.isNotEmpty) {
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
                    DoneBooking(widget.text,today,items[current],selectedService,priceTotal)));
              }
              else{
                if(selectedService.isEmpty) { setState(() => currentStep = currentStep);
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

  Widget buildCard({
    required Category sec,
  }) => Container(
    width: double.infinity,
    color: Colors.grey.withOpacity(0.1),
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
              itemCount: _map2[sec]!.length, // _map2[cate[x]]!.length
              itemBuilder: (BuildContext context , int index)=>
                  ServiceItem(serv: _map2[sec]![index]),
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
          this.priceTotal=0;
          for(int x = 0; x<selectedService.length; x++) {
            this.priceTotal += int.parse(selectedService[x].price);
          }
        });
      },
    );
  }

  Widget ServiceItem2({required Servicee serv}){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(serv.name,
            style:
            TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.black.withOpacity(0.70)
            )
        ),
        SizedBox(width: 16),
        Text("₪${serv.price}",
          style:
          TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900),
        ),
      ],
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
              controller: controller,
              onChanged:(value) {
                // search code
                filterSearchResults(value);
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
            height:400,
            // color: Colors.grey.withOpacity(0.1),
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: cateS.length,
                      separatorBuilder: (context, _) => SizedBox(height: 14),
                      itemBuilder: (context,index) => buildCard(sec: cateS[index]),
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
          lastStep(widget.text,today,items[current],selectedService,priceTotal),
    ),
  ];

  void filterSearchResults(String query) {
    Map<Category,List<Servicee>> dummySearchList = Map();
    dummySearchList.addAll(_map);
    List<Category> newCate = [];
    if(query.isNotEmpty) {
      Map<Category,List<Servicee>> dummyListData = Map();

      for (int x = 0; x < cate.length; x++) {

        Map<Category,List<Servicee>> dummySearchList = Map();
        dummySearchList.addAll(_map);
        bool happen = false;
        for (int j = 0; j < dummySearchList[cate[x]]!.length; j++) {
          if(dummySearchList[cate[x]]![j].name.toLowerCase().contains(query.toLowerCase())){
            dummyListData.putIfAbsent(cate[x], () => <Servicee>[]).add(dummySearchList[cate[x]]![j]);
            happen = true;
          }
        }
        if(happen){
          newCate.add(cate[x]);
        }
      }
      setState(() {
        _map2.clear();
        cateS.clear();
        _map2.addAll(dummyListData);
        cateS.addAll(newCate);
      });
      return;
    } else {
      setState(() {
        _map2.clear();
        cateS.clear();
        _map2.addAll(_map);
        cateS.addAll(cate);

      });
    }
  }
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




