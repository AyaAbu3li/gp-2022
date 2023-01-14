import 'package:flutter/widgets.dart';
import 'package:purple/screens/admin/components/add_admin.dart';
import 'package:purple/screens/admin/components/change_password.dart';
import 'package:purple/screens/forgot_password/forgot_password_screen.dart';
import 'package:purple/screens/admin/admin_screen.dart';
import 'package:purple/screens/salon/salon_screen.dart';
import 'package:purple/screens/sign_in/sign_in_screen.dart';
import 'package:purple/screens/sign_in/sign_up_salon/sign_up_salon_screen.dart';
import 'package:purple/screens/sign_in/sign_up/sign_up_screen.dart';
import 'package:purple/screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SignUpSalonScreen.routeName: (context) => SignUpSalonScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  adminScreen.routeName: (context) => adminScreen(),
  salonScreen.routeName: (context) => salonScreen(0),
  addAdmin.routeName: (context) => addAdmin(),
  changePassword.routeName: (context) => changePassword(),


};