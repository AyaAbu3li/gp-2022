import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../components/default_button.dart';
import 'ProfilePage.dart';
import 'package:purple/global.dart' as global;

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final _formKey = GlobalKey<FormState>();
  String message ='';
  final fieldText = TextEditingController();

  void save() async {
    try{
      var res = await http.post(Uri.parse("http://"+ip+":3000/messages"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
            'Authorization': global.token
          },
          body: <String, String>{
            'message': message
          });

      showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Sent'),
            content: Text("Thank you for contact with us."),
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
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
      );
      setState(() {
        message = '';
        fieldText.clear();
      });

    } catch(e){
      print(" hiiii");
      print(e);
    }
  }
  String errorPassImg ="assets/icons/white.svg";
  String pass ='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Contact us"),
        backgroundColor: Colors.purple.shade300,
        centerTitle: true,
      ),
      body:
    Form(
    key: _formKey,
    child:SizedBox(
          width: double.infinity,
          child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
              children: [
                logoWidget("assets/images/help.png"),
                  Text("Send us a message/feedback",
                    style:TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold,
                        fontSize: 22)
                  ),

                  TextFormField(
                    controller: fieldText,
                      onChanged: (value) {
                        message = value;
                      },
                    validator: (Password) {
                      if (Password == null || Password.isEmpty) {
                        setState(() {
                          errorPassImg = "assets/icons/Error.svg";
                          pass = 'Write a message';
                        });
                        return "";
                      }else{
                          setState(() {
                            errorPassImg = "assets/icons/white.svg";
                            pass = '';
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
                      ),
                      minLines: 6,
                      maxLines: null,
                  ),
                SizedBox(height: getProportionateScreenHeight(20)),

                DefaultButton(
                    text: "Send",
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        save();
                      }
                    }
                ),
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
              ],
              ),
            )
          )
      )
    )
    );
  }

  Image logoWidget(String imageName){
    return Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 200,
      height: 200,
    );
  }
}
