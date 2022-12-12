import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:purple/screens/admin/components/salons_requests.dart';
import 'package:purple/screens/admin/components/who_are_we.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'account.dart';
import 'offers.dart';
import 'offers_requests.dart';
import 'alerts.dart';
import 'salons_page.dart';
import 'package:http/http.dart' as http;
import 'feed_back.dart';

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

                // Padding(
                //   padding: const EdgeInsets.all(10),
                //   child:
                //   Row( children: [
                //     Expanded(
                //
                //         child: Container(
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               SizedBox( height: 5.0),
                //               Image.asset('assets/images/rating.png',
                //                 height: 70,width: 70,
                //               ),
                //
                //               SizedBox( height: 10.0),
                //               Text('User2s: '+'2',
                //                 style: TextStyle(
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.black,
                //                 ),
                //               ),
                //               SizedBox( height: 5.0),
                //             ],
                //           ),
                //           decoration: BoxDecoration(
                //             image: const DecorationImage(
                //               image: AssetImage('assets/images/IMG_3129.jpg'),
                //               fit: BoxFit.cover,
                //             ),
                //
                //
                //             borderRadius: BorderRadius.circular(10.0,),
                //
                //             // border: Border.all(color: Colors.purpleAccent),
                //             color: Colors.white,
                //
                //           ),
                //         ),
                //
                //
                //     ),
                //     SizedBox( width: 20.0),
                //     Expanded(
                //
                //         child: Container(
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               SizedBox( height: 5.0),
                //               Image.asset('assets/images/ecommerce.png',
                //                 height: 70,width: 70,
                //               ),
                //
                //               SizedBox( height: 10.0),
                //               Text('Salons: '+'2',
                //                 style: TextStyle(
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.black,
                //                 ),
                //               ),
                //               SizedBox( height: 5.0),
                //             ],
                //           ),
                //           decoration: BoxDecoration(
                //             image: const DecorationImage(
                //               image: AssetImage('assets/images/IMG_3129.jpg'),
                //               fit: BoxFit.cover,
                //             ),
                //
                //             borderRadius: BorderRadius.circular(10.0,),
                //             // border: Border.all(color: Colors.purpleAccent),
                //             color: Colors.white,
                //
                //           ),
                //         ),
                //
                //
                //     ),
                //   ],),
                // ),

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
                            builder: (context) => const SalonsPage(),
                          )
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/hair-salon.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('All Salons',
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
                            builder: (context) => const SalonsRequests(),
                          )
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/quote-request.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('Salon Requests',
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
                            builder: (context) => const offerRequests(),
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
                              Text('Offer Requests',
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
                              Text('Offers',
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
                            builder: (context) => const Feed_back(),
                          )
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/social-media.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('Feedback',
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
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const whoAreWe(),
                          ));
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox( height: 5.0),
                              Image.asset('assets/images/information.png',
                                height: 70,width: 70,
                              ),

                              SizedBox( height: 10.0),
                              Text('Who are we',
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