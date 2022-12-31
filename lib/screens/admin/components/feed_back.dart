import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../user/HomeScreen.dart';
import '../admin_screen.dart';
import 'package:http/http.dart' as http;

enum Actions { delete }

class Feed_back extends StatefulWidget {
  const Feed_back({Key? key}) : super(key: key);
  @override
  State<Feed_back> createState() => _Feed_backState();
}
class _Feed_backState extends State<Feed_back> {
  List<Feed> f = [];
  bool circular = true;
  bool empty = false;

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
          empty = true;
        }
        circular = false;
      });
    } catch(e){
      print(" hiiii");
      print(e);
    }
  }
  void delete(id) async {
    try{
      var res = await http.delete(Uri.parse("http://"+ip+":3000/messages/"+id),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
      );
    } catch(e){
      print("delete");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavigationDrawer(),
    appBar: AppBar(title: const Text('Feedback')),
      body: circular
          ? Center(child: CircularProgressIndicator())
           : empty
          ? Center(child: Text("No Feedback yet!",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black)))
      : SlidableAutoCloseBehavior(
              closeWhenOpened: true,
              child: ListView.builder(
                itemCount: f.length,
                itemBuilder: (context,index){
                final fed2 = f[index];
                return Slidable(
                  key: Key(fed2.name),
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      dismissible: DismissiblePane(
                        onDismissed: () => _onDismissed(index, Actions.delete),
                      ),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: (context) => _onDismissed(index, Actions.delete),
                        ),
                      ],
                      ),
                      child: buildFeeds(fed2),
                );
              },
              ),
            ),
  );

  void _onDismissed(int index, Actions action) {
    final fed2 = f[index];
    setState(() => f.removeAt(index));
    delete(fed2.id);
    _showSnackBar(context, '${fed2.name} feedback has been deleted',Colors.red);
  }
  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    if(f.isEmpty) {
      setState(() => empty = true);
    }
  }
  Widget buildFeeds(Feed fed) => Builder(
      builder: (context) => ListTile(
    contentPadding: const EdgeInsets.all(16),
      title: Text(fed.name),
      subtitle: Text(fed.message),
      leading: CircleAvatar(
        backgroundImage: AssetImage(fed.picture),
        radius: 30,
      ),
    onTap: (){
      final slidable = Slidable.of(context)!;
      final isClosed =
          slidable.actionPaneType.value == ActionPaneType.none;
      if(isClosed){
        slidable.openStartActionPane();
      } else slidable.close();
    },
      ),
  );

 }

  class  Feed {
    final String id;
    final String name;
  final String message;
  final String picture;

  const Feed({
    required this.id,
    required this.name,
    required this.message,
    required this.picture,

  }  );

  static Feed fromJson(json) => Feed(
    id: json['_id'],
    name: json['name'],
    message: json['message'],
    picture: json['picture'],

  );
}