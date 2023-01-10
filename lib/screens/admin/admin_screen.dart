import 'dart:convert';
import 'package:flutter/material.dart';
import '../../Model/user.dart';
import '../../constants.dart';
import '../sign_in/sign_in_screen.dart';
import 'components/account.dart';
import 'components/alerts.dart';
import 'components/body.dart';
import 'components/salons_page.dart';
import 'components/salons_requests.dart';
import 'components/who_are_we.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;

class adminScreen extends StatelessWidget {
  static String routeName = "/admin_home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Body(),
      drawer: NavigationDrawer(),
    );
  }
}
  class NavigationDrawer extends StatefulWidget {
    const NavigationDrawer({Key? key}) : super(key: key);
    _NavigationDrawerState createState() => _NavigationDrawerState();
  }

class _NavigationDrawerState extends State<NavigationDrawer> {
  User user = User('', '','','','','');
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
      user.email = decoded['email'];
      // user.picture = decoded['picture'];
    });
  }
  @override
    Widget build(BuildContext context) => Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  buildHeader(BuildContext context) => Material(
      color: Colors.purple,
      child: InkWell(
        onTap:() {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const account(),
          )
          );
        },
        child: Container(
          padding: EdgeInsets.only(
            top:24 + MediaQuery.of(context).padding.top,
            bottom: 24,
          ),
            child: Column(
                children: [
                CircleAvatar(
                radius: 52,
                  backgroundImage: AssetImage("assets/images/log.png"),
            ),
              SizedBox(height: 12),
               Text(
                 user.name,
                style: TextStyle(fontSize: 28,
                    color: Colors.white
                ),
                ),
              Text(
                user.email,
                style: TextStyle(fontSize: 17,
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  buildMenuItems(BuildContext context) =>Container(

    padding: EdgeInsets.all(20),
      child: Wrap(
    runSpacing: 10,
    children: [
      Text(
        'Home',
        style: TextStyle(fontSize: 17,
        ),
      ),
      ListTile(
        leading: Icon(Icons.home, color: Colors.purple),
        title: const Text('Home',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>  adminScreen(),
          )
                );
        },
    ),
    ListTile(
      leading: Icon(Icons.storefront, color: Colors.purple),
      title: const Text('Salons',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SalonsPage(),
      ));
    },
    ),
      const Divider(color: Colors.black54),
      Text(
        'Account',
        style: TextStyle(fontSize: 17,
        ),
      ),
      ListTile(
      leading: Icon(Icons.person, color: Colors.purple),
      title: const Text('My Account',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const account(),
        )
        );
      },
      ),
      ListTile(
      leading: Icon(Icons.monitor, color: Colors.purple),
      title: const Text('New Salons Requests',
        style: TextStyle(
          fontSize: 17,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SalonsRequests(),
        )
        );
      },
      ),
      ListTile(
      leading: Icon(Icons.notification_add, color: Colors.purple),
      title: const Text('Send Notifications',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const alert(),
        )
        );
      },
      ),
      const Divider(color: Colors.black54),
      Text(
        'Application',
        style: TextStyle(fontSize: 17,
        ),
      ),
      ListTile(
        leading: Icon(Icons.question_mark, color: Colors.purple),
        title: const Text('Who are we',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const whoAreWe(),
          ));
        },
      ),
    ListTile(
      leading: Icon(Icons.logout, color: Colors.purple),
      title: const Text('Logout',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: () async {
          try{
            var res = await http.post(Uri.parse("http://"+ip+":3000/users/logout"),
              headers: <String, String>{
                'Context-Type': 'application/json;charSet=UTF-8',
                'Authorization': global.token
              },
            );
            Navigator.push(context, MaterialPageRoute(builder:(context) => SignInScreen()));
          } catch(e){
            print(" hiiii");
            print(e);
          }
      },
      ),
    ],
      ),
  );
  }
