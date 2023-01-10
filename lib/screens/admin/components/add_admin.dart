import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Model/user.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../admin_screen.dart';
import 'package:http/http.dart' as http;


class addAdmin extends StatefulWidget {
  static String routeName = "/add_admin";
  @override
  _addAdminState createState() => _addAdminState();
}

class _addAdminState extends State<addAdmin> {
  final _formKey = GlobalKey<FormState>();

  void save() async {
    try{
      var res = await http.post(Uri.parse("http://"+ip+":3000/users"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          },
          body: <String, String>{
            'name': user.name,
            'email': user.email,
            'password': user.password,
            'phone': user.phone,
            'picture': user.picture,
            'role': '2',
            'city': 'Jenin'
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
              title: Text('Admin'),
              content: Text("Admin account created succecfully"),
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
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => adminScreen()) ),
                ),
              ],
            ),
      );

    } catch(e){
      print(" hiiii");
      print(e);
    }
  }

  User user = User('', '','','','');

  String Name="";
  String email="";
  String password="";

  String data ='';
  String errorPassImg ="assets/icons/white.svg";
  String errorPhoneImg ="assets/icons/white.svg";
  String errorImg ="assets/icons/white.svg";
  String errorNameImg ="assets/icons/white.svg";
  String pass ='';
  String namme ='';
  String phone ='';
  bool _isObscure = true;




  @override
Widget build(BuildContext context) => Scaffold(

  appBar: AppBar(
title: const Text('Add New Admin'),
),
body:

SafeArea(
child: SizedBox(
width: double.infinity,
child: Padding(
padding:
EdgeInsets.symmetric(horizontal:
getProportionateScreenWidth(20)),
child: SingleChildScrollView(
child: Column(
children: [
  Form(
    key: _formKey,
    child: Column(
        children: [
        SizedBox( height: 20.0),
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
                      child: Ink.image(
                        image: NetworkImage
                          ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBxdgiNFnmCxkR1QUu8IKgGOZIMHlu6fbGZA&usqp=CAU'),
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
        const Divider(color: Colors.black54),
        SizedBox( height: 10.0),
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
          buildNameFormField(),

          Row(
            children: [
              SvgPicture.asset(
                errorImg,
                height: getProportionateScreenWidth(14),
                width: getProportionateScreenWidth(14),
              ),
              SizedBox(width: getProportionateScreenWidth(10),),
              Text(data),
            ],
          ),
          buildEmailFormField(),

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
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: 'Phone',
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
              SizedBox(width: getProportionateScreenWidth(10),),
              Text(pass),
            ],
          ),
          buildPasswordFormField(),

          SizedBox(height: SizeConfig.screenHeight * 0.02),
        DefaultButton(
          text: "Add new admin",
          press: () {
            if (_formKey.currentState!.validate()) {
                  save();

            }
          },
        ),
],
  ),
),
],
),
),
),
),
),
);

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
        user.password = value;
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
              errorPassImg =  "assets/icons/Error.svg";
              pass = "Short password";
            });
            return "";
          }else
            setState(() {
              errorPassImg = 'assets/icons/white.svg';
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
            data = "Invalid Email";
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
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            data = '';
          });
        }
        user.email = value;
      },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.alternate_email,
          color: Colors.purple ,
        ),
        labelText: 'Enter your email',
        labelStyle: TextStyle(color: Colors.black),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
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
          Icons.drive_file_rename_outline,
          color: Colors.purple ,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        labelText: 'Enter your name',
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }


}