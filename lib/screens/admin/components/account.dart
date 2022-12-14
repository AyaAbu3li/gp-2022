import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../admin_screen.dart';
import 'add_admin.dart';
import 'change_password.dart';
import 'package:http/http.dart' as http;
import 'package:purple/Model/user.dart';
import 'package:purple/global.dart' as global;

class account extends StatefulWidget {
  const account({Key? key}) : super(key: key);
  @override
  _accountState createState() => _accountState();
}

class _accountState extends State<account> {
  final _formKey = GlobalKey<FormState>();

  User user = User('', '','','','','');
  bool circular = true;
  String errorPhoneImg ="assets/icons/white.svg";
  String phone ='';
  String namme ='';
  String errorNameImg ="assets/icons/white.svg";

  @override
  void initState() {
    super.initState();
    fetchData();
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
    // user.picture = decoded['picture'];
    user.phone = decoded['phone'].toString();
    circular = false;

    });
  }
  void edit() async {
    try{
      var res = await http.patch(Uri.parse("http://"+ip+":3000/users/me"),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        'Authorization': global.token
      },
        body: <String, String>{
          'name': user.name,
          'phone': user.phone,
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
        @override
        Widget build(BuildContext context) => Scaffold(
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

                SizedBox( height: 20.0),

                Row( children: [
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                  clipBehavior: Clip.none, fit: StackFit.expand,
                  children: [
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
                            child: Ink.image(image: AssetImage('assets/images/cam.png')
                              // child: Ink.image(image: NetworkImage
                            // ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBxdgiNFnmCxkR1QUu8IKgGOZIMHlu6fbGZA&usqp=CAU'),
                            ),
                onPressed: () {


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

                      SizedBox( width: 50.0),

                      Text(user.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        ),
                      ],
                      ),

                        const Divider(color: Colors.black54),

                        Row( children: [
                          Text('Name',
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            ),
                          ),
                        ],
                        ),


                       SizedBox( height: 5.0),

                        TextFormField(
                        initialValue: user.name,
                        // readOnly: true,
                        keyboardType: TextInputType.text,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                errorNameImg = 'assets/icons/white.svg';
                                namme = '';
                              });
                            }
                            user.name = value;
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
                            Icons.person,
                            color: Colors.purple ,
                          ),
                        border: UnderlineInputBorder(),
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


                // SizedBox( height: 5.0),

                        Row( children: [
                          Text('Email',
                          style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          ),
                          ),
              ],
              ),
                        SizedBox( height: 5.0),

                      TextFormField(
                        initialValue: user.email,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.purple ,
                        ),
                        border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        ),
                      ),
                      SizedBox( height: 20.0),

                      Row( children: [
                        Text('Phone',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        ),
                      ],
                      ),


                      SizedBox( height: 5.0),

                      TextFormField(
                        initialValue: user.phone,
                        // readOnly: true,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              errorPhoneImg = 'assets/icons/white.svg';
                              phone = '';
                            });
                          }
                          user.phone = value;
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
                      text: "Edit",
                      press: () {
                      if (_formKey.currentState!.validate()) {
                        edit();
                      } else { print("not oky");}
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                            onPressed: () {
                              Navigator.pushNamed(context, changePassword.routeName);
                          },
                            child: Text('Change password',style: TextStyle(fontSize: getProportionateScreenWidth(18),color: Colors.white)),),
                      ),

                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                          SizedBox(
                            width: double.infinity,
                            height: getProportionateScreenHeight(56),
                            child:
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.purple[200],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, addAdmin.routeName);
                                },
                                child: Text('Add Admin',
                                  style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  color: Colors.white,),
                                ),
                              ),
                          ),

    ],
    ),
    ),
    ),
    ),
    ),



    )
  );
}