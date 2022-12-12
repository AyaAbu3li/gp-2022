import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../user/HomeScreen.dart';
import '../admin_screen.dart';
import 'package:http/http.dart' as http;

class Feed_back extends StatefulWidget {
  const Feed_back({Key? key}) : super(key: key);
  @override
  State<Feed_back> createState() => _Feed_backState();
}
class _Feed_backState extends State<Feed_back> {
  List<Feed> f = [];
  bool circular = true;

  @override
  void initState() {
    super.initState();
    getFeed();
  }
  void getFeed() async {
    var data;
    try{
      var res = await http.get(Uri.parse("http://"+ip+":3000/Allmessages"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
      );
      data = json.decode(res.body);
      setState(() {
        this.f = data.map<Feed>(Feed.fromJson).toList();
        if(f.isEmpty){
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('come back later'),
                  content: Text("There are no messages at the moment"),
                  actions: [
                    TextButton(
                      child: Text('OK',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            color: Colors.white,)),
                      style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () =>  Navigator.push(
                          context, MaterialPageRoute(builder: (context) => HomeScreen())),
                    ),
                  ],
                ),
          );
        }
        circular = false;
      });
    } catch(e){
      print(" hiiii");
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavigationDrawer(),
    appBar: AppBar(title: const Text('Feedback')),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  child: buildFeeds(f),
                ),
              ),
            ),
          ],
      ),
  );

  Widget buildFeeds(List<Feed> fed) => ListView.builder(
    itemCount: fed.length,
    itemBuilder: (context,index){
      final fed2 = fed[index];
      return Card(
        elevation: 40,
          child: GestureDetector(
          onTap: (){
            print("Container clicked");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SalonPage(saloon.id.toString())));
      },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(fed2.picture),
            radius: 28,
          ),
          title: Text(fed2.name),
          subtitle: Text(fed2.message),
        ),
          )
      );
    },
  );


}

class  Feed {
  final String name;
  final String message;
  final String picture;


  const Feed({
    required this.name,
    required this.message,
    required this.picture,

  }  );

  static Feed fromJson(json) => Feed(
    name: json['name'],
    message: json['message'],
    picture: json['picture'],

  );
}