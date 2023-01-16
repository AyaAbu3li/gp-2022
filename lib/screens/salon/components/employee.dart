import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;
import '../salon_screen.dart';
import 'employee_page.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/services.dart';


class employee extends StatefulWidget {
  const employee({Key? key}) : super(key: key);
  @override
  State<employee> createState() => _employeeState();
}

class _employeeState extends State<employee> {
  final _formKey = GlobalKey<FormState>();
  List<Employee> employees = [];

  bool circular = true;
  String errorNameImg ="assets/icons/white.svg";
  String namme ='';
  File? image;
  String imageUrl = '';

  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if(img == null) return;
      final img_temp = File(img.path);

      setState(() {
        this.image = img_temp;

      });

    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  void myAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text(' From Gallery',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purpleAccent,),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text(' From Camera',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Emp em = Emp('','','');
  @override
  void initState() {
    super.initState();
    getEmployees();
  }
  void getEmployees() async {
    var data;

    var res2 = await http.get(Uri.parse("http://"+ip+":3000/users/me"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        });
    var decoded = json.decode(res2.body);
    String name = decoded['name'];
    try{
      var res = await http.get(Uri.parse("http://"+ip+":3000/employee/"+name),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
      );
      data = json.decode(res.body);
      setState(() {
        this.employees = data.map<Employee>(Employee.fromJson).toList();
        circular = false;
      });
    } catch(e){
      print(" employee");
      print(e);
    }
  }
  void add() async {
    try{

      if( image != null) {
        final cloudinary = CloudinaryPublic('dsmn9brrg', 'ul29zf8l');

        CloudinaryResponse resImage = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image!.path, folder: em.name),
        );

        setState(() {
          imageUrl = resImage.secureUrl;
          em.picture = imageUrl;
        });
      }else {
        setState(() {
          em.picture = "https://res.cloudinary.com/dsmn9brrg/image/upload/v1673876307/dngdfphruvhmu7cie95a.jpg";
        });
      }

      var res = await http.post(Uri.parse("http://"+ip+":3000/employee"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
            'Authorization': global.token
          },
          body: <String, String>{
            'name': em.name,
            'picture': em.picture,
            'job': em.job
          });

      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Done'),
              content: Text("New employee has been Added succecfully"),
              actions: [
                TextButton(
                  child: Text('OK',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        color: Colors.white,)
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => employee()) ),
                ),
              ],
            ),
      );

    } catch(e){
      print("add employee");
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavigationDrawer(),
    appBar: AppBar(title: const Text('employees')),
    body: circular
        ? Center(child: CircularProgressIndicator())
          :SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      Container(
                        height: 130,
                        child: ListView.separated(
                          padding: EdgeInsets.all(6),
                          scrollDirection: Axis.horizontal,
                          itemCount: employees.length,
                          separatorBuilder: (context, _) => SizedBox(width: 18),
                          itemBuilder: (context,index) => buildCard(employees: employees[index]),

                        ),
                      ),                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      const Divider(color: Colors.black54),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          clipBehavior: Clip.none, fit: StackFit.expand,
                          children: [
                            image != null
                                ?
                            CircleAvatar(
                                backgroundImage: new FileImage(image!),
                                radius: 200.0)
                                :
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/Profile Image2.png'),
                            ),
                            Positioned(
                              right: -16,
                              bottom: 0,
                              child: SizedBox(
                                height: 46,
                                width: 46,
                                child: TextButton(
                                  child: Ink.image(image: AssetImage('assets/images/cam.png')
                                  ),
                                  onPressed: () {
                                    myAlert();
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: BorderSide(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                    ),
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                      TextFormField(
                        onChanged: (value) {
                          em.name = value;
                        },
                        validator: (Name) {
                          if (Name == null || Name.isEmpty) {
                            setState(() {
                              errorNameImg =  "assets/icons/Error.svg";
                              namme = 'Please enter employee info';
                            });
                            return "";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.drive_file_rename_outline,
                            color: Colors.purple ,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Employee name',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      TextFormField(
                        onChanged: (value) {
                          em.job = value;
                        },
                        validator: (Name) {
                          if (Name == null || Name.isEmpty) {
                            setState(() {
                              errorNameImg =  "assets/icons/Error.svg";
                              namme = 'Please enter employee info';
                            });
                            return "";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.work_outline,
                            color: Colors.purple ,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Employee job',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      DefaultButton(
                        text: "Add employee",
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            add();
                          }
                        },
                      ),

                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      Row(
                        children: [
                          SvgPicture.asset(
                            errorNameImg,
                            height: getProportionateScreenWidth(14),
                            width: getProportionateScreenWidth(14),
                          ),
                          SizedBox(width: getProportionateScreenWidth(10),),
                          Text(namme),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
    ),
  );
// }

  Widget buildCard({
    required Employee employees,
  }) => GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => employeepage(employees.id.toString())));
    },
    child: Container(
      width: 113,
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 4/3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  employees.picture,
                  fit: BoxFit.cover,
                ),
              ),
            ),),

          const SizedBox(height: 4,),
          Text(
            employees.name,
            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            employees.job,
            style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
class Employee{
  final String picture;
  final String name;
  final String job;
  final String id;

  const Employee({
    required this.picture,
    required this.name,
    required this.job,
    required this.id,

  });
  static Employee fromJson(json) => Employee(
    name: json['name'],
    picture: json['picture'],
    job: json['job'],
    id: json['_id'],

  );
}

class Emp {
  String picture;
  String name;
  String job;

  Emp(this.picture,
      this.name,
      this.job,);
}