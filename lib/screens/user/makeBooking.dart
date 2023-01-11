import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../Model/salon.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;
import '../../Model/Booking.dart';
import '../../Model/user.dart';
import '../../components/default_button.dart';
import '../../size_config.dart';
import 'BookingScreen.dart';
import 'HomeScreen.dart';

class DoneBooking extends StatefulWidget {
  final String text;
  final String time;
  final int priceTotal;
  final DateTime today;
  final List<Servicee> selectedService1;
  const DoneBooking(this.text,this.today,this.time,this.selectedService1,this.priceTotal);
  @override
  State<DoneBooking> createState() => _DoneBookingState();
}

class _DoneBookingState extends State<DoneBooking> {

  User user = User('', '', '', '', '', '');
  Salon salon = Salon(
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '');
  bool circular = true;
  Booking booking = Booking('','','','','','','','','');
  @override
  void initState() {
    super.initState();
    fetchData();
    this.circular = false;

  }
  void fetchData() async {
    try {
      var res = await http.get(Uri.parse("http://"+ip+":3000/users/me"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      setState(() {

        var decoded = json.decode(res.body);
        user.name = decoded['name'];
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
      });
      var resB = await http.post(Uri.parse("http://"+ip+":3000/booking"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
            'Authorization': global.token
          },
          body: <String, String>{
            'SalonName': salon.name,
            'SalonEmail': salon.email,
            'time': widget.time,
            'date': widget.today.toString().split(" ")[0],
            'price': widget.priceTotal.toString()
          });
      var decoded = json.decode(resB.body);

      setState(() {
        booking.id = decoded['_id'];
      });


      for(int x = 0 ; x < widget.selectedService1.length ; x++) {
        var res2 = await http.post(
            Uri.parse("http://" + ip + ":3000/bookingServices"),
            headers: <String, String>{
              'Context-Type': 'application/json;charSet=UTF-8',
            },
            body: <String, String>{
              'service': widget.selectedService1[x].name,
              'owner': booking.id,
              'salonEmail': salon.email
            });
      }


    } catch (e) {
      print("Make booking");
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: circular
          ? Center(child: CircularProgressIndicator())
          :
      Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Image.asset(
            "assets/images/su.png",
            height: SizeConfig.screenHeight * 0.4, //40%
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.08),
          Text(
            "Booking Success",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(30),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Spacer(),
          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: DefaultButton(
              text: "Back to home",
              press: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
  }
