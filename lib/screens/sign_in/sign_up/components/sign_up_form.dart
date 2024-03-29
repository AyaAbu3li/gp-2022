import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:purple/components/default_button.dart';
import '../../sign_in_screen.dart';
import 'package:http/http.dart' as http;
import '../../../../constants.dart';
import '../../../../size_config.dart';
import 'package:purple/Model/user.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  _SignUpFormState(){
    valueChoose= listItem[0];
  }
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


  void save() async {
    try{

      if( image != null) {
        final cloudinary = CloudinaryPublic('dsmn9brrg', 'ul29zf8l');

        CloudinaryResponse resImage = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image!.path, folder: user.name),
        );

        setState(() {
          imageUrl = resImage.secureUrl;
          user.picture = imageUrl;
        });
      }else {
        setState(() {
          user.picture = "https://res.cloudinary.com/dsmn9brrg/image/upload/v1673876307/dngdfphruvhmu7cie95a.jpg";
        });
      }
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
          'city': valueChoose

        });
      if(res.statusCode == 400){
        setState(() {
          errorImg = "assets/icons/Error.svg";
          data = "Email exits";
        });
        return;
      }
      print(res.body);

      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Welcome'),
              content: Text("Your account created succecfully"),
              actions: [
                TextButton(
                  child: Text('Sign in',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        color: Colors.white,)),
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

  User user = User('', '','','','','');

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
  String valueChoose = "Jenin";
  bool _isObscure = true;
  final listItem = [
    "Jenin", "Nablus" , "Ramallah", "Tullkarm", "Tubas", "Hebron", "Qalqelia"
  ];
  @override
  Widget build(BuildContext context) {
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
                image != null
                    ?
                CircleAvatar(
                    backgroundImage: new FileImage(image!),
                    radius: 200.0)
                    :
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/Profile Image2.png"),
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
                errorNameImg,
                height: getProportionateScreenWidth(14),
                width: getProportionateScreenWidth(14),
              ),
              SizedBox(width: getProportionateScreenWidth(10),),
              Text(namme),
            ],
          ),
          buildNameFormField(),

          // SizedBox(height: getProportionateScreenHeight(10)),
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

          // SizedBox(height: getProportionateScreenHeight(10)),
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
          SizedBox(height: getProportionateScreenHeight(10)),
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
                user.city = valueChoose;
              });
            },
            items: listItem.map((valueItem)=>
                DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                )
            ).toList(),
          ),

          SizedBox(height: getProportionateScreenHeight(10)),
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

          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                save();
              }else { print("not oky");}
            },
          ),
          Text(
            'By continuing your confirm that you agree \nwith our Term and Condition',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
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