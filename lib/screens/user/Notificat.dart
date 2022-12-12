import 'package:flutter/material.dart';

class Notificat extends StatefulWidget {
  const Notificat({Key? key}) : super(key: key);

  @override
  State<Notificat> createState() => _NotificatState();
}

class _NotificatState extends State<Notificat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Notification"),
        centerTitle: true,

      ),
    );
  }
}

class  Notification {
  final String name;
  final String description;
  final String image;

  const Notification({
    required this.name,
    required this.description,
    required this.image
  }  );

  static Notification fromJson(json) => Notification(
    name: json['name'],
    description: json['description'],
    image: json['image'],
  );
}
