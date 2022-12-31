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

  Emp em = Emp('','','');
  @override
  void initState() {
    super.initState();
    getEmployees();
  }
  void getEmployees() async {
    var data;
    try{
      var res = await http.get(Uri.parse("http://"+ip+":3000/employee"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      data = json.decode(res.body);
      setState(() {
        this.employees = data.map<Employee>(Employee.fromJson).toList();
        circular = false;
      });
    } catch(e){
      print(" hiiii");
      print(e);
    }
  }
  void add() async {
    try{
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
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/cam.png'),
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