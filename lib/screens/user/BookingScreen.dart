import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// import 'book.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';

//final currentStep = StateProvider((ref) => 1);
//final selectedCity = StateProvider((ref) => '');
//final selectedSalon = StateProvider((ref) => '');

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);



  @override
  State<BookingScreen> createState() => _BookingScreenState();
}



class _BookingScreenState extends State<BookingScreen> {

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
          backgroundColor: Colors.purple,
          title: Text("Make a Reservation"),
          centerTitle: true,

        ),
        body: Theme(
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



/*
                controlsBuilder: (BuildContext context, {onStepContinue, onStepCancel}) {
                return Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Row(
                    children: [
                      Expanded(child:
                      ElevatedButton(
                        child: Text(
                          'BACK',
                        ),
                        onPressed: onStepContinue,
                      ),
                      ),
                    ],
                  ),


              );
                 },
*/


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
      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0,top: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              sec,
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black87.withOpacity(0.5),),
            ),
          ),
        ),

        Expanded(
          child: Container(
            //  color: Colors.green,

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
          ? Icon(Icons.check_circle,color: Colors.blue,)
          : Icon(Icons.check_circle_outline_outlined,color: Colors.grey,),
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

  List<Step> getSteps() =>[
    Step( state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,title: Text('Services'),
      content: SingleChildScrollView(
      child: Column(
        children: [


          Row(
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Services",
                          style: TextStyle(color: Colors.purple.shade900,fontSize: 26,fontWeight: FontWeight.bold,),textAlign: TextAlign.left,)),
                    SizedBox(height: 0,),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Text(
                            "Select your needs",
                            style: TextStyle(color: Colors.black54,fontSize: 19,),textAlign: TextAlign.left,),
                        )),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Container(
                  width: (MediaQuery.of(context).size.width) * 0.45,

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
              SizedBox(height: 10,),

            ],
          ),

          SizedBox(
            height: 2,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height:480,
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
                        separatorBuilder: (context, _) => SizedBox(height: 14,),
                        itemBuilder: (context,index) => buildCard(sec: sec[index]),


                      ),
                    ),
                  ),

                ],
              ),

            ),
          ),


          /*
          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => book()));

            },
            child: Text("NEXT", style: TextStyle(
              fontSize: 20,
              letterSpacing: 5,
              color: Colors.white,
            ),),
            style: ElevatedButton.styleFrom(
              primary: Colors.purple.shade600,
              padding: EdgeInsets.symmetric(horizontal: 150,vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),

           */
          //   value: SystemUiOverlayStyle.light,
        ],
      ),
    ),),
    Step(state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,title: Text('Book a spot'), content: SingleChildScrollView(
      child: Column(
        children: [
          Text("Select the appropriate day ", style: TextStyle(fontSize: 22,color: Colors.purple),),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15,top: 4,bottom: 10),
            child: Container(
              // color: Colors.purple.withOpacity(0.1),
              child: TableCalendar(
                rowHeight: 40,
                headerStyle: HeaderStyle(formatButtonVisible: false,titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2010,10,16),
                lastDay: DateTime.utc(2030,3,14),
                onDaySelected: _onDaySelected,
              ),
            ),
          ),
          SizedBox(height: 22),
          SizedBox(height: 15),
          Text("Select the appropriate Time ", style: TextStyle(fontSize: 22,color: Colors.purple),),
          SizedBox(height: 15),
          Container(
            margin:  const EdgeInsets.only(left: 0,right: 7),
            height: 70,
            //   color: Colors.blue,
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
          SizedBox(height: 9,),


          Text("Selected Day = " + today.toString().split(" ")[0],style: TextStyle(fontSize:12,color: Colors.black,),),
          Text("Selected Time = " +items[current],style: TextStyle(fontSize: 12,color: Colors.black,),),

          SizedBox(
            height: 30,
          ),
          //   value: SystemUiOverlayStyle.light,
        ],
      ),
    ),),
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

class ServiceModel{
  String serviceName;
  bool isSelected;

  ServiceModel(this.serviceName, this.isSelected);

}




