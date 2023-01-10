import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:purple/screens/forgot_password/forgot_password_screen.dart';
import 'package:purple/screens/admin/admin_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:purple/screens/user/HomeScreen.dart';
import 'package:purple/Model/user.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;
import '../../salon/salon_screen.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();

  void save() async {
    try{
    var res = await http.post(Uri.parse("http://"+ip+":3000/users/login"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
        body: <String, String>{
          'email': user.email,
          'password': user.password
        });
    if(res.statusCode == 400){
      setState(() {
        errorPassImg = "assets/icons/Error.svg";
        pass = "email or password is not correct";
      });
      return;
    }
    var decoded = json.decode(res.body);
    global.token = decoded['token'];
    print(global.token);
    Map<String, dynamic> u = decoded['user'];
    global.city = u['city'];
    if(u['role'] == 0) { // user
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else if(u['role'] == 1) { // saloon
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => salonScreen()));
      } else if(u['role'] == 2) { // admin
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => adminScreen()));
    } else {
      setState(() {
        errorPassImg = "assets/icons/Error.svg";
        pass = "email or password is not correct";
      });
      return;
    }
    } catch(e){
      print(" hiiii");
      print(e);
    }
  }

  String email = "";
  String password = "";

  User user = User('', '','','','','');
  bool _isObscure = true;
  String data = '';
  String errorPassImg = "assets/icons/white.svg";
  String errorImg = "assets/icons/white.svg";
  String pass = '';
  String str = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
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

          SizedBox(height: getProportionateScreenHeight(10)),
          buildPasswordFormField(),
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
          SizedBox(height: getProportionateScreenHeight(10)),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: getProportionateScreenWidth(16),

                    // fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                save();
              } else {
                print("not ok");
              }
              },
          ),
        ],
      ),
    );
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
          color: Colors.purple,
        ),
        suffixIcon: IconButton(
            icon: Icon(
                color: Colors.purple,
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
        user.email = value;
      },

      validator: (Email) {
        if (Email == null || Email.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            data = 'Please enter your email';
          });
          return "";
        } else if (!EmailValidator.validate(Email, true)) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
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
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Colors.purple,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        labelText: 'Enter your email',
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
