import 'package:flutter/material.dart';

class Feedbackk extends StatefulWidget {
  const Feedbackk({Key? key}) : super(key: key);

  @override
  State<Feedbackk> createState() => _FeedbackkState();
}

class _FeedbackkState extends State<Feedbackk> {

  List<Feed> f = getFeed();

  static List<Feed> getFeed(){
    const data = [
      {
        "name": "Yara_mohammad",
        "description":"Very Good",
        "image":"https://image.shutterstock.com/image-photo/african-american-woman-wearing-business-260nw-1846459081.jpg",
      },
      {
        "name": "Amal",
        "description":"Nice services",
        "image":"data:image/jpeg;base64,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",
      },


    ];
    return data.map<Feed>(Feed.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Feedback",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.purple.shade300,
        centerTitle: true,
      ),

      body:
      Column(
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
  }

  Widget buildFeeds(List<Feed> fed) => ListView.builder(
    itemCount: fed.length,
    itemBuilder: (context,index){
      final fed2 = fed[index];
      return Card(

        elevation: 40,
        //clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: CircleAvatar(
            radius: 28,
       //  backgroundImage: NetworkImage(fed2.image),
        //   backgroundImage: Image.asset(offerr.image),
          ),
          title: Text(fed2.name),
          subtitle: Text(fed2.description),
        ),
      );

    },
  );
}

class  Feed {
  final String name;
  final String description;
  final String image;


  const Feed({
    required this.name,
    required this.description,
    required this.image,

  }  );

  static Feed fromJson(json) => Feed(
    name: json['name'],
    description: json['description'],
    image: json['image'],

  );
}