//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:purple/Model/notification_model.dart';
import 'package:purple/screens/admin/components/alerts.dart';
//import 'package:timeago/timeago.dart' as timeago;

class Notificat extends StatefulWidget {
  const Notificat({Key? key}) : super(key: key);

  @override
  State<Notificat> createState() => _NotificatState();
}

class _NotificatState extends State<Notificat> {
/*
buildComments(){
  return StreamBuilder(


    stream:  commentsRef.doc().collection('comments').orderBy(
        "timestamp",descending: false).snapshots(),

  builder: (context, snapshot) {
     if(!snapshot.hasData) {
  return circularProgress();
}
    
  }
  );
}*/

  @override
  Widget build(BuildContext context) {
    print(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Notification"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("comments").orderBy("timestamp", descending: true).snapshots(),
            builder: (context, snapshot) {
           if(snapshot.hasData) { final data=snapshot.data!.docs;
              return ListView.separated(
                shrinkWrap: true,
              itemCount: data.length,  
                itemBuilder: (context, index) {
final notf=ClassNotificationModel.fromJson(data[index].data());
print("imad ${notf.timestamp}");
                  return ListTile(
title: Text(notf.username!),
subtitle: Text(notf.comment!),trailing: Text(
                        GetTimeAgo.parse(  notf.timestamp!.toDate()),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold),
                      ),
leading:CircleAvatar(backgroundImage:  AssetImage(notf.avatarUrl!),),

                  );
                }, separatorBuilder: (BuildContext context, int index) {
                   return     Divider(color: Colors.black54, indent: 0, endIndent: 0);
},

              );
          } else return Center(child: CircularProgressIndicator(),); },
          ),
          /* Expanded(child: 
          buildComments(),
          ),
          */
          Divider(color: Colors.black54, indent: 0, endIndent: 0),
        ],
      ),
    );
  }
}

class Notification {
  final String name;
  final String description;
  final String image;

  const Notification(
      {required this.name, required this.description, required this.image});

  static Notification fromJson(json) => Notification(
        name: json['name'],
        description: json['description'],
        image: json['image'],
      );
}

/*
class Comment extends StatelessWidget {
final String username;
final String avatarUrl;
final Timestamp timestamp;
final String comment;

/*Comment({
  this.username ,
  this.avatarUrl,
  this.comment,
  this.timestamp,
});
*/

factory Comment.fromDocument(DocumentSnapshot doc){
  return Comment(
    username: doc['username'],
    avatarUrl: doc['avatarUrl'],
    comment: doc['comment'],
    timestamp: doc['timestamp'],
  );
}
  @override 
  Widget build(BuildContext context){
    return Column(
      children: [
        ListTile(
           title: Text(comment),
           leading: CircleAvatar(backgroundImage: 
           AssetImage(avatarUrl),
           ),
           subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }
} */