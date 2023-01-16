import 'dart:convert';
import 'package:flutter/material.dart';
import '../../Model/user.dart';
import '../../constants.dart';
import '../sign_in/sign_in_screen.dart';
import 'Help.dart';
import 'MyAccount.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;
import 'appointment.dart';
import 'who_are_we.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = User('', '','','','','');
  bool circular = true;

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
      user.picture = decoded['picture'];
      circular = false;

    });
  }
  void logout() async {
    try{
      var res = await http.post(Uri.parse("http://"+ip+":3000/users/logout"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
            'Authorization': global.token
          },
          );
      Navigator.push(context, MaterialPageRoute(builder:(context) => SignInScreen()));

    } catch(e){
      print("hiiii");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Profile"),
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          :Column(
        children: [
          SizedBox(height: 30),
          SizedBox(
            height: 115,
              width: 115,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.picture),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(user.name,
            style: TextStyle(fontSize: 23,color: Colors.black),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: TextButton(
              style:TextButton.styleFrom(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: Color(0xFFF5F6F9),
              ) ,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyAccount()));
              },
              child: Row(
                children: [
                  Icon(Icons.person_outline,size: 30,color: Colors.purple,),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Text(
                      "My Account",
                      style: TextStyle(fontSize: 20,color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,color: Colors.purple,),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: TextButton(
              style:TextButton.styleFrom(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: Color(0xFFF5F6F9),
              ) ,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>Appointment()));
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_month_outlined,size: 30,color: Colors.purple,),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Text(
                      "My Appointments",
                      style: TextStyle(fontSize: 20,color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,color: Colors.purple,),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: TextButton(
              style:TextButton.styleFrom(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: Color(0xFFF5F6F9),
              ) ,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>whoAreWe()));
              },
              child: Row(
                children: [
                  Icon(Icons.help_outline_outlined,size: 30,color: Colors.purple,),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Text(
                      "Who are we",
                      style: TextStyle(fontSize: 20,color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,color: Colors.purple,),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: TextButton(
              style:TextButton.styleFrom(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: Color(0xFFF5F6F9),
              ) ,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Help()));
              },
              child: Row(
                children: [
                  Icon(Icons.chat_bubble_outline_outlined,size: 30,color: Colors.purple,),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Text(
                      "Contact Us",
                      style: TextStyle(fontSize: 20,color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,color: Colors.purple,),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: TextButton(
              style:TextButton.styleFrom(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: Color(0xFFF5F6F9),
              ) ,
              onPressed: (){
                logout();
              },
              child: Row(
                children: [
                  Icon(Icons.logout,size: 30,color: Colors.purple,),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Text(
                      "Log Out",
                      style: TextStyle(fontSize: 20,color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,color: Colors.purple,),
                ],
              ),
            ),
          ),

        ],
      ),


    );
  }
}
