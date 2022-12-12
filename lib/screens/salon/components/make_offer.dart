import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
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

      var res2 = await http.post(Uri.parse("http://"+ip+":3000/offerservice"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
            'Authorization': global.token
          },
          body: <String, String>{
            'service': offer.name,
            'owner': offer.id
          });


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
      appBar: AppBar(
        title: Text("Make offer"),
        centerTitle: true,
      ),
      body:
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

                  SizedBox(
                    width: SizeConfig.screenWidth * 0.55,
                    height: getProportionateScreenHeight(45),
                    child:
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                      onPressed: () {
                        // Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                      child: Text('Choose services',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          color: Colors.white)
                      ),
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
                      text: "Make Offer",
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
  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
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