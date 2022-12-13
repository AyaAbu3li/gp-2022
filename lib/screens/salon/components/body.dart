import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'account.dart';
import 'employee.dart';
import 'offers.dart';
import 'make_offer.dart';
import 'alerts.dart';
import 'Help.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  State<Body> createState() => _BodyState();
}
class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal:
        getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox( height: 10.0),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                  Row( children: [
                    Expanded(
                      child: InkWell(
                        onTap:() {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const account(),
                          )
                          );
                        },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox( height: 5.0),
                            Image.asset('assets/images/account.png',
                              height: 70,width: 70,
                            ),

                            SizedBox( height: 10.0),
                            Text('Account',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox( height: 5.0),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0,),
                          border: Border.all(color: Colors.purpleAccent),
                          color: Colors.white,

                        ),
                      ),
                    ),

                      ),
                    SizedBox( width: 20.0),
                    Expanded(
                      child: InkWell(
                        onTap:() {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const alert(),
                          )
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/smartphone.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('Alerts',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox( height: 5.0),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0,),
                            border: Border.all(color: Colors.purpleAccent),
                            color: Colors.white,

                          ),
                        ),
                      ),

                    ),
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                  Row( children: [
                    Expanded(
                      child: InkWell(
                        onTap:() {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const makeOffer(),
                          )
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/megaphone.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('Make an Offer',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox( height: 5.0),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0,),
                            border: Border.all(color: Colors.purpleAccent),
                            color: Colors.white,

                          ),
                        ),
                      ),

                    ),
                    SizedBox( width: 20.0),
                    Expanded(
                      child: InkWell(
                        onTap:() {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const offers(),
                          )
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/advertising.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('My Offers',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox( height: 5.0),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0,),
                            border: Border.all(color: Colors.purpleAccent),
                            color: Colors.white,

                          ),
                        ),
                      ),

                    ),
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                  Row( children: [
                    Expanded(
                      child: InkWell(
                        onTap:() {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => const makeOffer(),
                          // )
                          // );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/make-up-6.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('Add Service',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox( height: 5.0),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0,),
                            border: Border.all(color: Colors.purpleAccent),
                            color: Colors.white,

                          ),
                        ),
                      ),

                    ),
                    SizedBox( width: 20.0),
                    Expanded(
                      child: InkWell(
                        onTap:() {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => const offers(),
                          // )
                          // );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/make-up.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('My Services',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox( height: 5.0),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0,),
                            border: Border.all(color: Colors.purpleAccent),
                            color: Colors.white,

                          ),
                        ),
                      ),

                    ),
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                  Row( children: [
                    Expanded(
                      child: InkWell(
                        onTap:() {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => const Booking(),
                          // )
                          // );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/calendar.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('Booking',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox( height: 5.0),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0,),
                            border: Border.all(color: Colors.purpleAccent),
                            color: Colors.white,

                          ),
                        ),
                      ),

                    ),
                    SizedBox( width: 20.0),
                    Expanded(
                      child: InkWell(
                        onTap:() {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const employee(),
                          )
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/employee.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('employees',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox( height: 5.0),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0,),
                            border: Border.all(color: Colors.purpleAccent),
                            color: Colors.white,

                          ),
                        ),
                      ),

                    ),
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                  Row( children: [
                    Expanded(
                      child: InkWell(
                        onTap:() {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => const makeOffer(),
                          // )
                          // );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/messaging.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('Chat',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox( height: 5.0),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0,),
                            border: Border.all(color: Colors.purpleAccent),
                            color: Colors.white,

                          ),
                        ),
                      ),

                    ),
                    SizedBox( width: 20.0),
                    Expanded(
                      child: InkWell(
                        onTap:() {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Help(),
                          )
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/mail.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('Contact Us',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox( height: 5.0),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0,),
                            border: Border.all(color: Colors.purpleAccent),
                            color: Colors.white,

                          ),
                        ),
                      ),

                    ),
                  ],),
                ),

                SizedBox( height: 20.0),
              ],
            ),
        ),
      ),
      ),
    );
  }
}
class User2 {
  final int role;

  const User2( {
    required this.role,

  }  );

  static User2 fromJson(json) => User2(
    role: json['role'],

  );
}