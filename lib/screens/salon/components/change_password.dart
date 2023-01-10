import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:purple/screens/admin/components/account.dart';
import '../../../Model/user.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../salon_screen.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;


class changePassword extends StatefulWidget {
  static String routeName = "/change_password";
  @override
  _changePasswordState createState() => _changePasswordState();
}
class _changePasswordState extends State<changePassword> {

  final _formKey = GlobalKey<FormState>();
  String errorPassImg ="assets/icons/white.svg";
  String pass ='';
  String errorPassImg2 ="assets/icons/white.svg";
  String pass2 ='';
  bool _isObscure = true;
  bool _isObscure2 = true;
  User user = User('', '','','','','');
  String password2 = '';


  void edit() async {
    try{
      var res = await http.patch(Uri.parse("http://"+ip+":3000/users/me"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
            'Authorization': global.token
          },
          body: <String, String>{
            'password': user.password,
          });
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Changed'),
              content: Text("Your password has been successfully changed"),
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
                  onPressed: () =>  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => account())),

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

  appBar: AppBar(
title: const Text('Change Password'),
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
    Row( children: [
    Text('Write your new password',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    ],),
    SizedBox( height: 5.0),
    TextFormField(
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
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
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
    SizedBox( height: 10.0),
    Row( children: [
    Text('Confirm your new password',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),


    ],),
    SizedBox( height: 5.0),
    TextFormField(
      obscureText: _isObscure2,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorPassImg2 = 'assets/icons/white.svg';
            pass2 = '';
          });
        }
        password2 = value;
      },
      validator: (Password) {
        if (Password == null || Password.isEmpty) {
          setState(() {
            errorPassImg2 =  "assets/icons/Error.svg";
            pass2 = 'Please enter your password';
          });
          return "";
        }else if (Password.isNotEmpty) {
          if (Password.length < 4) {
            setState(() {
              errorPassImg2 =  "assets/icons/Error.svg";
              pass2 = "Short password";
            });
            return "";
          }else
            setState(() {
              errorPassImg2 = 'assets/icons/white.svg';
              pass2 = '';
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
                _isObscure2 ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscure2 = !_isObscure2;
              });
            }),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    ),
  Row(
    children: [
      SvgPicture.asset(
        errorPassImg2,
        height: getProportionateScreenWidth(14),
        width: getProportionateScreenWidth(14),
      ),
      SizedBox(width: getProportionateScreenWidth(10),),
      Text(pass2),
    ],
  ),
    SizedBox(height: SizeConfig.screenHeight * 0.03),
    DefaultButton(
    text: "Change",
    press: () {
      if (_formKey.currentState!.validate()) {
            if(password2 == user.password){
              edit();
            }else{
              setState(() {
                errorPassImg2 =  "assets/icons/Error.svg";
                pass2 = "Passwords do not match";
              });
            }
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
}