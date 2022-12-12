import 'package:flutter/material.dart';
import 'AllSalonPage.dart';
import 'Home.dart';
import 'ProfilePage.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 int index = 0;
 final screens = [
   Home(),
   AllSalonPage(),
   Center(child: Text('Chats', style: TextStyle(fontSize: 72))),
    ProfilePage(),
 ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: screens[index],
      backgroundColor: Colors.white,
   /* appBar:  AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        "Home Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold , color: Colors.purple),
      ),
      elevation: 0,
    ), */

      bottomNavigationBar: Container(
       height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 15,
              offset: Offset(0,5),
            ),
          ],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
              topRight: Radius.circular(24)),
        ),


        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.blue.shade100,
            labelTextStyle: MaterialStateProperty.all(TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
          child: NavigationBar(
            height: 62,
            backgroundColor: Colors.white,
            selectedIndex: index,
            onDestinationSelected: (index) =>
                setState( () => this.index = index),
            destinations: [
              NavigationDestination(icon: Icon(Icons.home_outlined,color: Colors.black87,size: 35,),selectedIcon:
                Icon(Icons.home,color: Colors.purple,size: 38,), label: 'Home'),

              NavigationDestination(icon: Icon(Icons.storefront,color: Colors.black87,size: 35,),
                selectedIcon: Icon(Icons.storefront_rounded,color: Colors.purple,size: 38,),label: 'Salons'),

              NavigationDestination(icon: Icon(Icons.message_outlined,color: Colors.black87,size: 35,),
                selectedIcon: Icon(Icons.message_sharp,color: Colors.purple,size: 38,), label: 'Chats'),

              NavigationDestination(icon: Icon(Icons.person_outline,color: Colors.black87,size: 35,),selectedIcon:
                Icon(Icons.person,color: Colors.purple,size: 38,), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}





