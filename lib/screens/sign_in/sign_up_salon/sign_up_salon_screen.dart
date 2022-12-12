import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpSalonScreen extends StatelessWidget {
  static String routeName = "/sign_up_salon";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Us"),
      ),
      body: Body(),
    );
  }
}