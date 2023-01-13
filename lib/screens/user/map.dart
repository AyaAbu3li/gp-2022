import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../components/default_button.dart';
import '../../size_config.dart';
import 'HomeScreen.dart';

class mapp extends StatefulWidget {
  mapp({Key? key}) : super(key: key);

  @override
  State<mapp> createState() => _mappState();
}

class _mappState extends State<mapp> {

  String LocationMessage = 'Location Message';

  late String long;
  late String lat;


  Future<void> _openmap(String lat, String long) async {

    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';

    await canLaunchUrlString(googleURL)
    ? await launchUrlString(googleURL)
    : throw 'could not launch $googleURL';
  }

    Future<Position> _getCurrentLocation() async {

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request');
      }
      return await Geolocator.getCurrentPosition();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Image.asset(
            "assets/images/su.png",
            height: SizeConfig.screenHeight * 0.4, //40%
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.08),
          Text(
            LocationMessage,
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
              text: "Get current location",
              press: () {
                _getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';
                  setState(() {
                    LocationMessage = 'Latitude: $lat, Longitude: $long';
                  });
                  _openmap(lat,long);
                });

              }
          ),
          ),
          Spacer(),
        ],
      ),
    );
  }
  }
