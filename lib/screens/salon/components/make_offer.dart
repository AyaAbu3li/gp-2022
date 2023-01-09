import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../Model/category.dart';
import '../../../Model/salon.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../salon_screen.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;

class makeOffer extends StatefulWidget {
  const makeOffer({Key? key}) : super(key: key);
  @override
  State<makeOffer> createState() => _makeOfferState();
}
class _makeOfferState extends State<makeOffer> {
  final _formKey = GlobalKey<FormState>();

  Offer offer = Offer('','','','','');
   String data = '';
   String errorImg = "assets/icons/white.svg";
   String errorPassImg = "assets/icons/white.svg";
   String pass = '';



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




  void makeOffer() async {
    try{
      var res = await http.post(Uri.parse("http://"+ip+":3000/offers"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
        body: <String, String>{
          'name': offer.name,
          'startdate': offer.startdate,
          'enddate': offer.enddate,
          'price': offer.price
        });
      var decoded = json.decode(res.body);

      setState(() {
        offer.id = decoded['_id'];
      });

      for(int x = 0 ; x < selectedService.length ; x++) {
        var res2 = await http.post(
            Uri.parse("http://" + ip + ":3000/offerservice"),
            headers: <String, String>{
              'Context-Type': 'application/json;charSet=UTF-8',
              'Authorization': global.token
            },
            body: <String, String>{
              'service': selectedService[x].name,
              'owner': offer.id
            });
      }

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
      print("Make offer");
      print(e);
    }
  }

  DateTimeRange dateRange = DateTimeRange(
       start: DateTime.now(),
       end: DateTime.now().add(Duration(days: 10))
   );

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    final difference = dateRange.duration;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text("Make offer"),
        centerTitle: true,
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : empty
          ? Center(child: Text("You have no Services",
          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black)))
          :
      SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    TextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            errorImg = 'assets/icons/white.svg';
                            data = '';
                          });
                        }
                        offer.name = value;
                      },
                      validator: (Email) {
                        if (Email == null || Email.isEmpty) {
                          setState(() {
                            errorImg = "assets/icons/Error.svg";
                            data = 'Please enter offer name';
                          });
                          return "";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.local_offer_outlined,
                          color: Colors.purple,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        labelText: 'Offer name',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          errorImg,
                          height: getProportionateScreenWidth(14),
                          width: getProportionateScreenWidth(14),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        Text(data),
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),

                  // SizedBox(
                  //   width: SizeConfig.screenWidth * 0.55,
                  //   height: getProportionateScreenHeight(45),
                  //   child:
                  //   TextButton(
                  //     style: TextButton.styleFrom(
                  //       backgroundColor: kPrimaryColor,
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  //     ),
                  //     onPressed: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => const services()
                  //       )
                  //       );
                  //           },
                  //     child: Text('Choose services',
                  //       style: TextStyle(
                  //         fontSize: getProportionateScreenWidth(18),
                  //         color: Colors.white)
                  //     ),
                  //   ),
                  // ),

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

                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            errorPassImg = 'assets/icons/white.svg';
                            pass = '';
                          });
                        }
                        offer.price = value;
                      },
                      validator: (Password) {
                        if (Password == null || Password.isEmpty) {
                          setState(() {
                            errorPassImg = "assets/icons/Error.svg";
                            pass = 'Please enter price';
                          });
                          return "";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: Colors.purple,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        labelText: 'Offer price',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          errorPassImg,
                          height: getProportionateScreenWidth(14),
                          width: getProportionateScreenWidth(14),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        Text(pass),
                      ],
                    ),
                    Text('Select offer duration',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    )),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                backgroundColor: kPrimaryColor),
                              onPressed: pickDateRange,
                              child: Text(DateFormat('yyyy/MM/dd').format(start),
                                  style: TextStyle(
                                      fontSize: getProportionateScreenWidth(18))
                              ),
                          ),
                          ),
                          SizedBox(width: SizeConfig.screenWidth * 0.01),
                          Expanded(
                            child: ElevatedButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: kPrimaryColor),
                                onPressed: pickDateRange,
                                child: Text(DateFormat('yyyy/MM/dd').format(end),
                                    style: TextStyle(
                                        fontSize: getProportionateScreenWidth(18))
                                ),
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    Text('Offer duration: ${difference.inDays} days',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        )),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    DefaultButton(
                      text: "Make the Offer",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          makeOffer();
                        } else {
                          print("not ok");
                        }
                      },
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                  ]
                ),
              ),
            ),
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

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purpleAccent, // <-- SEE HERE
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDateRange == null) return;

    setState(() => {
      dateRange = newDateRange,
      offer.startdate = convertDateTimeDisplay(dateRange.start.toString()),
      offer.enddate = convertDateTimeDisplay(dateRange.end.toString()),
    });
  }
}
String convertDateTimeDisplay(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

class Offer {
   String name;
   String price;
   String enddate;
   String startdate;
   String id;

   Offer(
      // {
     this.name,
     this.price,
     this.startdate,
     this.enddate,
     this.id,

  // }
  );
  // static Offer fromJson(json) => Offer(
  //   name: json['name'],
  //   price: json['price'],
  //   startdate: json['startdate'],
  //   enddate: json['enddate'],
  //   id: json['_id'],
  // );

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
