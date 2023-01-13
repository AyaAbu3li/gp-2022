//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:purple/screens/user/Notificat.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purple/screens/user/Notificat.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final DateTime timestamp = DateTime.now();

class alert extends StatefulWidget {
  const alert({Key? key}) : super(key: key);
  @override
  State<alert> createState() => _alertState();
}

class _alertState extends State<alert> {
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Emp em = Emp('','');

  String errorNameImg ="assets/icons/white.svg";
  String namme ='';

 @override

 void initState(){
  getUsers();
 // createUser();

  super.initState();
 }

 createUser() async{
  userRef.add({
   "username" : "Purple",
  });
 }

getUsers(){
  userRef.get().then((QuerySnapshot snapshot) {
snapshot.docs.forEach((DocumentSnapshot doc) {
  print(doc.data());
});
  });
}

addComment() {
  commentsRef.add(
    {
     "username" : "Purple",
     "comment": commentController.text,
     "timestamp": timestamp,
     "avatarUrl" : "assets/images/log.png",
    }

  );
    commentController.clear();
}


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Alerts'),
    ),
    body: SafeArea(
      child: SizedBox(
      width: double.infinity,
        child: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              
              SizedBox(height: SizeConfig.screenHeight * 0.02),

              TextFormField(
                controller: commentController,
                onChanged: (value) {
                  em.details = value;
                },
              
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.add_alert,
                    color: Colors.purple ,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: 'Alert details',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                minLines: 3,
                maxLines: null,
              ),


              SizedBox(height: SizeConfig.screenHeight * 0.03),
              DefaultButton(
                text: "Send",
                press: () {
                 addComment();
                 print('add comment');
                 //return Notificat();
                },
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
            ]
            ),
          ),
        ),
      ),
    ),
  );



}
class Emp {
  String name;
  String details;

  Emp(
      this.name,
      this.details,);
}