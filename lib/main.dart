import 'package:flutter/material.dart';
import'package:purple/screens/splash/splash_screen.dart';
import 'package:purple/routes.dart';
import 'package:purple/theme.dart';

void main() {
  // runApp(MyApp());
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Purple',
      theme:theme(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );

  }
}
