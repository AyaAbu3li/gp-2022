import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../salon_screen.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class employeepage extends StatefulWidget {

  final String text;
  const employeepage(this.text);
  @override
  _employeepageState createState() => _employeepageState();
}

class _employeepageState extends State<employeepage> {
  final _formKey = GlobalKey<FormState>();

  bool circular = true;
  String errorPhoneImg ="assets/icons/white.svg";
  String phone ='';
  String namme ='';
  String errorNameImg ="assets/icons/white.svg";
  Emp em = Emp('','','');
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
    var res = await http.get(Uri.parse("http://"+ip+":3000/employe/"+widget.text),
      headers: <String, String>{
      'Context-Type': 'application/json;charSet=UTF-8',
      });
    setState(() {
      var decoded = json.decode(res.body);
      em.name = decoded['name'];
      em.picture = decoded['picture'];
      em.job = decoded['job'];
      circular = false;
    });
  }
  void edit() async {

      try{
        if( image != null) {
          final cloudinary = CloudinaryPublic('dsmn9brrg', 'ul29zf8l');

          CloudinaryResponse resImage = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(image!.path, folder: em.name),
          );

          setState(() {
            imageUrl = resImage.secureUrl;
            em.picture = imageUrl;
          });
        }

      var res = await http.patch(Uri.parse("http://"+ip+":3000/employee/"+widget.text),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
        body: <String, String>{
          'name': em.name,
          'job': em.job,
          'picture': em.picture
        });
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('modified'),
            content: Text("employee info has been successfully modified"),
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
    @override
    Widget build(BuildContext context) => Scaffold(
      // drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text('employee info'),
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
                  SizedBox( height: 20.0),
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
                            backgroundImage: NetworkImage(em.picture),
                          ),
                          Positioned(
                            right: -16,
                            bottom: 0,
                            child: SizedBox(
                              height: 46,
                              width: 46,
                              child: TextButton(
                                child: Ink.image(image: AssetImage('assets/images/cam.png') ),
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
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                    TextFormField(
                    initialValue: em.name,
                    keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            errorNameImg = 'assets/icons/white.svg';
                            namme = '';
                          });
                        }
                        em.name = value;
                      },
                      validator: (Name) {
                        if (Name == null || Name.isEmpty) {
                          setState(() {
                            errorNameImg =  "assets/icons/Error.svg";
                            namme = 'Please enter your name';
                          });
                          return "";
                        }
                        else if (Name.isNotEmpty) {
                          setState(() {
                            errorNameImg =  "assets/icons/white.svg";
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
                        borderRadius: BorderRadius.all(Radius.circular(30)),
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
                        SizedBox(width: getProportionateScreenWidth(10),),
                        Text(namme),
                      ],
                    ),

                    SizedBox( height: 5.0),

                    TextFormField(
                      initialValue: em.job,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            errorPhoneImg = 'assets/icons/white.svg';
                            phone = '';
                          });
                        }
                        em.job = value;
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
                        Icons.work_outline,
                        color: Colors.purple ,
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
                        SizedBox(width: getProportionateScreenWidth(10),),
                        Text(phone),
                      ],
                    ),

                    SizedBox(height: SizeConfig.screenHeight * 0.02),

                    DefaultButton(
                      text: "Edit employee info",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          edit();
                        } else { print("not oky");}
                        },
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),

                    SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(56),
                    child:
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {

                        // Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                      child: Text('Delete employee',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          color: Colors.white,),

                      ),
                    ),
                  ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                ]
              ),
            ),
          ),
        ),
      )
    )
  );
}
class Emp {
  String picture;
  String name;
  String job;

  Emp(this.picture,
      this.name,
      this.job,);
}