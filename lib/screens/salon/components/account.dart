import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:purple/screens/admin/components/salons_details.dart';
import '../../../Model/salon.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../salon_screen.dart';
import 'change_password.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/services.dart';


class account extends StatefulWidget {
  const account({Key? key}) : super(key: key);
  @override
  _accountState createState() => _accountState();
}

class _accountState extends State<account> {
  final _formKey = GlobalKey<FormState>();
  _accountState(){
    valueChoose= listItem[0];
    valueChoose2= listItem2[0];
  }
  Salon salon = Salon('','','','','','','','','','','','');

  bool circular = true;
  String errorPhoneImg ="assets/icons/white.svg";
  String phone ='';
  String namme ='';
  String errorNameImg ="assets/icons/white.svg";
  String valueChoose = "Jenin";
  String valueChoose2 = "Monday";

  final listItem2 = [
    "Monday", "Tuesday" , "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ];

  final listItem = [
    "Jenin", "Nablus" , "Ramallah", "Tullkarm", "Tubas", "Hebron", "Qalqelia"
  ];

  File? image;
  String imageUrl = '';

  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if(img == null) return;
      final img_temp = File(img.path);

      setState(() {
        this.image = img_temp;
      });

    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  void myAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text(' From Gallery',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purpleAccent,),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text(' From Camera',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

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
    valueChoose2 = decoded['holiday'];
    salon.picture = decoded['picture'];
    salon.phone = decoded['phone'].toString();
    salon.googlemaps = decoded['googlemaps'];
    salon.address = decoded['address'];
    salon.id = decoded['_id'];
     salon.openTime = decoded['openTime'];
     salon.closeTime = decoded['closeTime'];

    });
    time =
        TimeOfDay(hour:int.parse(salon.openTime.split(":")[0]),
            minute: int.parse(salon.openTime.split(":")[1].split(" ")[0]));

    time2 =
        TimeOfDay(hour:int.parse(salon.closeTime.split(":")[0]),
            minute: int.parse(salon.closeTime.split(":")[1].split(" ")[0]));
    circular = false;

  }
  void edit() async {

    try{
      if( image != null) {
        final cloudinary = CloudinaryPublic('dsmn9brrg', 'ul29zf8l');

        CloudinaryResponse resImage = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image!.path, folder: salon.name),
        );

        setState(() {
          imageUrl = resImage.secureUrl;
          salon.picture = imageUrl;
        });
      }
      var res = await http.patch(Uri.parse("http://"+ip+":3000/salons/"+salon.id),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        'Authorization': global.token
      },
        body: <String, String>{
          'name': salon.name,
          'phone': salon.phone,
          'city': valueChoose,
          'holiday': valueChoose2,
          'address': salon.address,
          'googlemaps': salon.googlemaps,
          'openTime': salon.openTime,
          'closeTime': salon.closeTime,
          // 'picture': user.picture
        });
      var res2 = await http.patch(Uri.parse("http://"+ip+":3000/users/me"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
            'Authorization': global.token
          },
          body: <String, String>{
            'name': salon.name,
            'phone': salon.phone,
            'city': valueChoose,
            'address': salon.address,
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

  TimeOfDay time = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay time2 = TimeOfDay(hour: 17, minute: 00);

        @override
        Widget build(BuildContext context) {

          DateTime tempDate1 = DateFormat("hh:mm").parse(
              time.hour.toString().padLeft(2, '0') +
                  ":" + time.minute.toString().padLeft(2, '0'));
          var dateFormat1 = DateFormat("hh:mm a"); // you can change the format here

          DateTime tempDate = DateFormat("hh:mm").parse(
              time2.hour.toString().padLeft(2, '0') +
                  ":" + time2.minute.toString().padLeft(2, '0'));
          var dateFormat = DateFormat("hh:mm "); // you can change the format here

          salon.closeTime = dateFormat.format(tempDate)+ 'PM';
          salon.openTime = dateFormat1.format(tempDate1);


          return Scaffold(
              drawer: NavigationDrawer(),
              appBar: AppBar(
                title: Text('Account'),
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
                                    image != null
                                        ?
                                    CircleAvatar(
                                        backgroundImage: new FileImage(image!),
                                        radius: 200.0)
                                        :
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          salon.picture),
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
                                          ),
                                          onPressed: () {
                                            myAlert();
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

                              Text('view as',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              IconButton(
                                iconSize: 35,
                                color: Colors.purple.shade500,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => salonsdetails(salon.id),
                                  )
                                  );
                                },
                                icon: Icon(
                                  Icons.remove_red_eye_outlined,
                                ),
                              )

                            ]),
                            const Divider(color: Colors.black54),
                            Row(children: [
                              Text('Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
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
                            ]),
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
                            ]),
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
                            ]),
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
                            ]),
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
                              Text('Excluded day',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField(
                              isExpanded: true,
                              hint: Text("Excluded day"),
                              icon: const Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.purple,
                              ),
                              dropdownColor: Colors.deepPurple.shade50,
                              decoration: InputDecoration(
                                labelText: 'Excluded day',
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.today_sharp,
                                  color: Colors.purple,
                                ),
                              ),
                              value: valueChoose2,
                              onChanged: (newValue2) {
                                setState(() {
                                  valueChoose2 = newValue2 as String;
                                });
                              },
                              items: listItem2.map((valueItem) =>
                                  DropdownMenuItem(
                                    value: valueItem,
                                    child: Text(valueItem),
                                  )
                              ).toList(),
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