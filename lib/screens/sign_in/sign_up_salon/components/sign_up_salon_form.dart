import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purple/components/default_button.dart';
import '../../../../Model/salon.dart';
import '../../sign_in_screen.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import 'package:http/http.dart' as http;

class SignUpSalonForm extends StatefulWidget {

  @override
  _SignUpSalonFormState createState() => _SignUpSalonFormState();
}

class _SignUpSalonFormState extends State<SignUpSalonForm> {
  // XFile? image;

  // final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  // Future getImage(ImageSource media) async {
  //   var img = await picker.pickImage(source: media);
  //
  //   setState(() {
  //     image = img;
  //   });
  // }


  late TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  late String long;
  late String lat;

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

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
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
                    //if user click this button, user can upload image from gallery
                  onPressed: () =>  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignInScreen())),

                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      // getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  final _formKey = GlobalKey<FormState>();
  void save() async {
    try{
      var res = await http.post(Uri.parse("http://"+ip+":3000/salons"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          },
          body: <String, String>{
            'name': salon.name,
            'email': salon.email,
            'password': salon.password,
            'phone': salon.phone,
            'address': salon.address,
            'city': valueChoose,
            'googlemaps': salon.googlemaps,
            'picture': salon.picture,
            'holiday': valueChoose2,
            'openTime': salon.openTime,
            'closeTime': salon.closeTime,
          });
      if(res.statusCode == 400){
        setState(() {
          errorImg = "assets/icons/Error.svg";
          data = "Email exits";
        });
        return;
      }
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Welcome'),
              content: Text("You will receive a message soon whether your application is accepted or not."),
              actions: [
                TextButton(
                  child: Text('OK',
                      style: TextStyle(
                       fontSize: getProportionateScreenWidth(14),
                       color: Colors.white,)
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => SignInScreen()) ),
                ),
              ],
            ),
      );

    } catch(e){
      print(" hiiii");
      print(e);
    }
  }

  Salon salon = Salon('','','','','','','','','','','','');
  String errorPhoneImg ="assets/icons/white.svg";
  String phone ='';
  String email="";
  String password="";
  final listItem2 = [
    "Monday", "Tuesday" , "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ];
  String valueChoose2 = "Monday";


  TimeOfDay time = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay time2 = TimeOfDay(hour: 5, minute: 00);


  String data ='';
  String errorPassImg ="assets/icons/white.svg";
  String errorImg ="assets/icons/white.svg";
  String pass ='';
  String errorNameImg ='';
  String namme ='';
  bool _isObscure = true;
  String valueChoose = "Jenin";
  final listItem = [
    "Jenin", "Nablus" , "Ramallah", "Tullkarm", "Tubas", "Hebron", "Qalqelia"
  ];
  @override
  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');

    final hours2 = time2.hour.toString().padLeft(2, '0');
    final minutes2 = time2.minute.toString().padLeft(2, '0');
    salon.closeTime = hours2+':'+minutes2;
    salon.openTime = hours+':'+minutes;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          clipBehavior: Clip.none, fit: StackFit.expand,
          children: [
            // image != null // هون كنت بجرب
            // ?CircleAvatar(
            //        backgroundImage: AssetImage("assets/images/Profile Image2.png"),
            //     )
            // :
            CircleAvatar(
               backgroundImage: AssetImage("assets/images/Profile Image.png"),
              ),
            Positioned(
              right: -16,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: TextButton(
                  child: Ink.image(
                    image: NetworkImage
                      ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBxdgiNFnmCxkR1QUu8IKgGOZIMHlu6fbGZA&usqp=CAU'),
                  ),
                  onPressed: () {
                    myAlert();

                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.white),
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
          SizedBox(height: getProportionateScreenHeight(20)),
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
          buildEmailFormField(),
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
          buildPasswordFormField(),
          Row(
            children: [
              SvgPicture.asset(
                errorNameImg,
                height: getProportionateScreenWidth(14),
                width: getProportionateScreenWidth(14),

              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Text(namme),
            ],
          ),
          buildNameFormField(),
          Row(
            children: [
              SvgPicture.asset(
                errorPhoneImg,
                height: getProportionateScreenWidth(14),
                width: getProportionateScreenWidth(14),
              ),
              SizedBox(width: getProportionateScreenWidth(10),),
              Text(phone),
            ],
          ),
          TextFormField(
            keyboardType: TextInputType.number,
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
                  errorPhoneImg =  "assets/icons/Error.svg";
                  phone = 'Please enter your phone';
                });
                return "";
              }else{
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
                color: Colors.purple ,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: 'Phone',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
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
                    hours+':'+minutes,
                    style: TextStyle(fontSize: 25),
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor),
                    child: Text('Open Time'),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: time,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                // change the border color
                                primary: Colors.purpleAccent,
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
              SizedBox(width: SizeConfig.screenWidth * 0.3),
              Column(
                children: [
                  Text(
                    hours2+':'+minutes2,
                    style: TextStyle(fontSize: 25),
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor),
                    child: Text('Close Time'),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: time2,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                // change the border color
                                primary: Colors.purpleAccent,
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
          TextFormField(
            onChanged: (value) {
              salon.address = value;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.location_city,
                color: Colors.purple ,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: 'Address',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
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
                salon.city = valueChoose;
              });
            },
            items: listItem.map((valueItem)=>
                DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                )
            ).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
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
          TextFormField(
            controller: controller,
            onChanged: (newValue) {
                salon.googlemaps = newValue;
              },
                decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.location_on_outlined,
                color: Colors.purple ,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: 'Google maps link',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),

          SizedBox(
            width: SizeConfig.screenWidth*0.7 ,
            height: getProportionateScreenHeight(46),
            child:
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                _getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';
                });
                print(lat);
                String googleURL =
                    'https://www.google.com/maps/search/?api=1&query=$lat,$long';
                insert(googleURL);
              },
              child: Text('Get your current location',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,),

              ),
            ),
          ),

          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                salon.picture = 'assets/images/Profile Image2.png';
                save();
              }
            }
            ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Text(
            'By continuing your confirm that you agree \nwith our Term and Condition',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
  void insert(String content) {
    var text = controller.text;
    var pos = 0;
    controller.value = TextEditingValue(
      text: text.substring(0, pos) + content + text.substring(pos),
      selection: TextSelection.collapsed(offset: pos + content.length),
    );
    setState(() {
      salon.googlemaps = content ;
        });
    print(salon.googlemaps);
  }
  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _isObscure,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorPassImg = 'assets/icons/white.svg';
            pass = '';
          });
        }
        salon.password = value;
      },
      validator: (Password) {
        if (Password == null || Password.isEmpty) {
          setState(() {
            errorPassImg =  "assets/icons/Error.svg";
            pass = 'Please enter your password';
          });
          return "";
        }else if (Password.isNotEmpty) {
          if (Password.length < 4) {
            setState(() {
              errorPassImg = "assets/icons/Error.svg";
              pass = "Short password";
            });
            return "";
          }else
            setState(() {
              errorPassImg = "assets/icons/white.svg";
              pass = '';
            });
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock_open,
          color: Colors.purple ,
        ),
        suffixIcon: IconButton(
            icon: Icon(
                color: Colors.purple ,
                _isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }),
        labelText: 'Enter your password',
        labelStyle: TextStyle(color: Colors.black),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }
  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            data = '';
          });
        }
        salon.email = value;
      },
      validator: (Email) {
        if (Email == null || Email.isEmpty) {
          setState(() {
            errorImg =  "assets/icons/Error.svg";
            data = 'Please enter your email';
          });
            return "";
        }else if(!EmailValidator.validate(Email, true)){
          setState(() {
            errorImg =  "assets/icons/Error.svg";
            data = "Invalid Email Address";
          });
          return "";
        }
        else if (Email.isNotEmpty) {
          setState(() {
            errorImg =  "assets/icons/white.svg";
            data = '';
          });
        }
        return null;
      },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Colors.purple ,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        labelText: 'Enter your email',
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }
  TextFormField buildNameFormField() {
    return TextFormField(
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
            errorNameImg =  "assets/icons/Error.svg";
            namme = 'Please enter sanlon name';
          });
          return "";
        }
        else if (Name.isNotEmpty) {
          setState(() {
            errorNameImg = 'assets/icons/white.svg';
            namme = '';
          });
        }
        return null;
      },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.drive_file_rename_outline,
          color: Colors.purple ,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),        labelText: 'Enter salon name',
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}