import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Model/salon.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../salon_screen.dart';
import 'change_password.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;

class account extends StatefulWidget {
  const account({Key? key}) : super(key: key);
  @override
  _accountState createState() => _accountState();
}

class _accountState extends State<account> {
  final _formKey = GlobalKey<FormState>();
  _accountState(){
    valueChoose= listItem[0];
  }
  Salon salon = Salon('','','','','','','','','','','');

  bool circular = true;
  String errorPhoneImg ="assets/icons/white.svg";
  String phone ='';
  String namme ='';
  String errorNameImg ="assets/icons/white.svg";
  String valueChoose = "Jenin";
  final listItem = [
    "Jenin", "Nablus" , "Ramallah", "Tullkarm", "Tubas", "Hebron", "Qalqelia"
  ];


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
     decoded = json.decode(res.body);
    salon.openTime = decoded['openTime'];
    salon.closeTime = decoded['closeTime'];
    salon.name = decoded['name'];
    salon.email = decoded['email'];
    valueChoose = decoded['city'];
    salon.picture = decoded['picture'];
    salon.phone = decoded['phone'].toString();
    salon.googlemaps = decoded['googlemaps'];
    salon.address = decoded['address'];
    salon.id = decoded['_id'];

    circular = false;

    });
    salon.openTime = decoded['openTime'];
    salon.closeTime = decoded['closeTime'];
  }
  void edit() async {

    try{
      var res = await http.patch(Uri.parse("http://"+ip+":3000/salons/"+salon.id),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        'Authorization': global.token
      },
        body: <String, String>{
          'name': salon.name,
          'phone': salon.phone,
          'city': valueChoose,
          'address': salon.address,
          'googlemaps': salon.googlemaps,
          'openTime': salon.openTime,
          'closeTime': salon.closeTime,
          // 'picture': user.picture
        });
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('modified'),
            content: Text("Your information has been successfully modified"),
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
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
      );
        } catch(e){
          print(" hiiii");
          print(e);
        }
    }
  late TimeOfDay time =
  TimeOfDay(hour:int.parse(salon.openTime.split(":")[0]),
      minute: int.parse(salon.openTime.split(":")[1]));

  late TimeOfDay time2 =
  TimeOfDay(hour:int.parse(salon.closeTime.split(":")[0]),
      minute: int.parse(salon.closeTime.split(":")[1]));

  // TimeOfDay time = TimeOfDay(hour: 11, minute: 30);
  // TimeOfDay time2 = TimeOfDay(hour: 12, minute: 30);

        @override
        Widget build(BuildContext context) {


          final hours = time.hour.toString().padLeft(2, '0');
          final minutes = time.minute.toString().padLeft(2, '0');

          final hours2 = time2.hour.toString().padLeft(2, '0');
          final minutes2 = time2.minute.toString().padLeft(2, '0');

          salon.closeTime = hours2+':'+minutes2;
          salon.openTime = hours+':'+minutes;

          return Scaffold(
              drawer: NavigationDrawer(),
              appBar: AppBar(
                title: const Text('Account'),
              ),
              body: circular
                  ? Center(child: CircularProgressIndicator())
                  : Form(
                key: _formKey,
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal:
                      getProportionateScreenWidth(20)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                            SizedBox(height: 20.0),

                            Row(children: [
                              SizedBox(
                                height: 115,
                                width: 115,
                                child: Stack(
                                  clipBehavior: Clip.none, fit: StackFit.expand,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                          salon.picture),
                                      // backgroundImage: AssetImage("assets/images/Profile Image.png"),
                                    ),
                                    Positioned(
                                      right: -16,
                                      bottom: 0,
                                      child: SizedBox(
                                        height: 46,
                                        width: 46,
                                        child: TextButton(
                                          child: Ink.image(image: AssetImage(
                                              'assets/images/cam.png')
                                            // child: Ink.image(image: NetworkImage
                                            // ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBxdgiNFnmCxkR1QUu8IKgGOZIMHlu6fbGZA&usqp=CAU'),
                                          ),
                                          onPressed: () {


                                          },
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(50),
                                              side: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(width: 50.0),

                              Text(salon.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                            ),

                            const Divider(color: Colors.black54),

                            Row(children: [
                              Text('Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                            ),
                            SizedBox(height: 5.0),

                            TextFormField(
                              initialValue: salon.name,
                              // readOnly: true,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    errorNameImg = 'assets/icons/white.svg';
                                    namme = '';
                                  });
                                }
                                salon.name = value;
                              },
                              validator: (Name) {
                                if (Name == null || Name.isEmpty) {
                                  setState(() {
                                    errorNameImg = "assets/icons/Error.svg";
                                    namme = 'Please enter your name';
                                  });
                                  return "";
                                }
                                else if (Name.isNotEmpty) {
                                  setState(() {
                                    errorNameImg = "assets/icons/white.svg";
                                    namme = '';
                                  });
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.purple,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)),
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                SvgPicture.asset(
                                  errorNameImg,
                                  height: getProportionateScreenWidth(14),
                                  width: getProportionateScreenWidth(14),
                                ),
                                SizedBox(width: getProportionateScreenWidth(
                                    10),),
                                Text(namme),
                              ],
                            ),
                            Row(children: [
                              Text('Email',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                            ),
                            SizedBox(height: 5.0),

                            TextFormField(
                              initialValue: salon.email,
                              readOnly: true,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.purple,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Row(children: [
                              Text('City',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                            ),
                            SizedBox(height: 5.0),

                            DropdownButtonFormField(
                              isExpanded: true,
                              hint: Text("Select City"),
                              icon: const Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.purple,
                              ),
                              dropdownColor: Colors.deepPurple.shade50,
                              decoration: InputDecoration(
                                labelText: 'Select City',
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.location_city_rounded,
                                  color: Colors.purple,
                                ),
                              ),
                              value: valueChoose,
                              onChanged: (newValue) {
                                setState(() {
                                  valueChoose = newValue as String;
                                });
                              },
                              items: listItem.map((valueItem) =>
                                  DropdownMenuItem(
                                    value: valueItem,
                                    child: Text(valueItem),
                                  )
                              ).toList(),
                            ),

                            SizedBox(height: 20.0),

                            Row(children: [
                              Text('Phone',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                            ),
                            SizedBox(height: 5.0),

                            TextFormField(
                              initialValue: salon.phone,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    errorPhoneImg = 'assets/icons/white.svg';
                                    phone = '';
                                  });
                                }
                                salon.phone = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    errorPhoneImg = "assets/icons/Error.svg";
                                    phone = 'Please enter your phone';
                                  });
                                  return "";
                                } else {
                                  setState(() {
                                    errorPhoneImg = 'assets/icons/white.svg';
                                    phone = '';
                                  });
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.purple,
                                ),
                                border: UnderlineInputBorder(),
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  errorPhoneImg,
                                  height: getProportionateScreenWidth(14),
                                  width: getProportionateScreenWidth(14),
                                ),
                                SizedBox(width: getProportionateScreenWidth(
                                    10),),
                                Text(phone),
                              ],
                            ),

                            SizedBox(height: SizeConfig.screenHeight * 0.01),
                            Row(children: [
                              Text('Opening Hours:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                            ),
                            SizedBox(height: SizeConfig.screenHeight * 0.01),

                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                salon.openTime,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    ElevatedButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: kPrimaryColor),
                                      child: Text('Edit open Time'),
                                      onPressed: () async {
                                        TimeOfDay? newTime = await showTimePicker(
                                          context: context,
                                          initialTime: time,
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme: ColorScheme.light(
                                                  // change the border color
                                                  primary: Colors.red,
                                                  // change the text color
                                                  onSurface: Colors.purple,
                                                ),
                                                // button colors
                                                buttonTheme: ButtonThemeData(
                                                  colorScheme: ColorScheme.light(
                                                    primary: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (newTime == null)
                                          return; // if CANCEL then null

                                        setState(() =>
                                        {
                                          time = newTime,
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(width: SizeConfig.screenWidth * 0.15),
                                Column(
                                  children: [
                                    Text(
                                      salon.closeTime,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    ElevatedButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: kPrimaryColor),
                                      child: Text('Edit close Time'),
                                      onPressed: () async {
                                        TimeOfDay? newTime = await showTimePicker(
                                          context: context,
                                          initialTime: time2,
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme: ColorScheme.light(
                                                  // change the border color
                                                  primary: Colors.red,
                                                  // change the text color
                                                  onSurface: Colors.purple,
                                                ),
                                                // button colors
                                                buttonTheme: ButtonThemeData(
                                                  colorScheme: ColorScheme.light(
                                                    primary: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (newTime == null)
                                          return; // if CANCEL then null

                                        setState(() =>
                                        {
                                          time2 = newTime,
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: SizeConfig.screenHeight * 0.01),

                            Row(children: [
                              Text('Address',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                            ),
                            SizedBox(height: 5.0),
                            TextFormField(
                              initialValue: salon.address,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                // user.name = value;
                              },
                              validator: (Name) {
                                return null;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.location_city,
                                  color: Colors.purple,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Row(children: [
                              Text('google maps link',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                            ),
                            SizedBox(height: 5.0),
                            TextFormField(
                              initialValue: salon.googlemaps,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                // user.name = value;
                              },
                              validator: (Name) {
                                return null;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.purple,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            SizedBox(height: SizeConfig.screenHeight * 0.02),

                            DefaultButton(
                              text: "Edit",
                              press: () {
                                if (_formKey.currentState!.validate()) {
                                  edit();
                                } else {
                                  print("not oky");
                                }
                              },
                            ),

                            SizedBox(height: SizeConfig.screenHeight * 0.01),
                            SizedBox(
                              width: double.infinity,
                              height: getProportionateScreenHeight(56),
                              child:
                              TextButton(
                                style: TextButton.styleFrom(
                                  // primary: Colors.purpleAccent, // foreground
                                  backgroundColor: Colors.purpleAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, changePassword.routeName);
                                },
                                child: Text('Change password', style: TextStyle(
                                    fontSize: getProportionateScreenWidth(18),
                                    color: Colors.white)),),
                            ),

                            SizedBox(height: SizeConfig.screenHeight * 0.04),


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          );
        }
}