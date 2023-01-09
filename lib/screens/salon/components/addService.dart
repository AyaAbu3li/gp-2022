import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Model/category.dart';
import '../../../Model/salon.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import 'package:purple/global.dart' as global;
import '../salon_screen.dart';
import 'employee_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'services.dart';


class addService extends StatefulWidget {

  const addService({Key? key}) : super(key: key);

  @override
  State<addService> createState() => _addServiceState();
}

class _addServiceState extends State<addService> {
  final _formKey = GlobalKey<FormState>();
  _addServiceState(){

  }
  Salon salon = Salon('','','','','','','','','','','','');
  List<Category> cate = [];
  List<Category> cate2 = [];

  bool circular = true;
  String errorNameImg ="assets/icons/white.svg";
  String namme ='';
  String valueChoose='MAKEUP';

  List<String> listItem = [];
  List<String> listItem2 = [];

  Emp em = Emp('','','');
  @override
  void initState() {
    super.initState();
    getcategorys();
  }
  void addService() async {

    try{
      var res1 = await http.get(Uri.parse("http://"+ip+":3000/salon"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      var decoded = json.decode(res1.body);

      setState(() {
        salon.email = decoded['email'];
      });


      var res2 = await http.get(Uri.parse("http://"+ip+":3000/category/"+ salon.email),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
          });
      var decoded2 = json.decode(res2.body);

      setState(() {
        this.cate2 = decoded2.map<Category>(Category.fromJson).toList();
      });
      if(cate2.isNotEmpty) {
        for (int x = 0; x < cate2.length; x++) {
          listItem2.add(cate2[x].category);
        }
      }
      if(!listItem2.contains(valueChoose) || cate2.isEmpty){
        try{
        var res = await http.post(Uri.parse("http://"+ip+":3000/category"),
            headers: <String, String>{
              'Context-Type': 'application/json;charSet=UTF-8',
              'Authorization': global.token
            },
            body: <String, String>{
              'category': valueChoose,
            });
      } catch(e){
      print("add category");
      print(e);
    }
      }

      var res = await http.post(Uri.parse("http://"+ip+":3000/services"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
            'Authorization': global.token
          },
          body: <String, String>{
            'name': em.name,
            'price': em.price,
            'category': valueChoose,
          });
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Added'),
              content: Text("Service has been successfully added"),
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
                  onPressed: () =>
                      Navigator.pop(context),
                ),
              ],
            ),
      );
    } catch(e){
      print(" edit");
      print(e);
    }
  }
    void getcategorys() async {
      try{
    var res3 = await http.get(Uri.parse("http://"+ip+":3000/Allcategory"),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    var cat;
    cat = json.decode(res3.body);

    setState(() {
      this.cate = cat.map<Category>(Category.fromJson).toList();
    });
    for (int x = 0; x < cate.length; x++) {
      listItem.add(cate[x].category);
    }
    circular = false;
    } catch(e){
      print("get categorys");
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Add Service')),
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
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                      TextFormField(
                        onChanged: (value) {
                          em.name = value;
                        },
                        validator: (Name) {
                          if (Name == null || Name.isEmpty) {
                            setState(() {
                              errorNameImg =  "assets/icons/Error.svg";
                              namme = 'Please enter Service info';
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
                          labelText: 'Service name',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      TextFormField(
                        onChanged: (value) {
                          em.price = value;
                        },
                        validator: (Name) {
                          if (Name == null || Name.isEmpty) {
                            setState(() {
                              errorNameImg =  "assets/icons/Error.svg";
                              namme = 'Please enter Service info';
                            });
                            return "";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                             Icons.attach_money,
                            color: Colors.purple ,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Service price',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      Row(children: [
                        Text('Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                      ),
                      SizedBox(height: 10),
                      DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint:
                        Row(
                          children: const [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.purple,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Select Category',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: listItem
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child:
                          Text(
                            item,
                            // style: const TextStyle(
                            //   fontSize: 14,
                            //   fontWeight: FontWeight.bold,
                            //   color: Colors.black,
                            // ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                            .toList(),
                        value: valueChoose,
                        onChanged: (value) {
                          setState(() {
                            valueChoose = value as String;
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        // iconSize: 20,
                        iconEnabledColor: Colors.purple,
                        // iconDisabledColor: Colors.grey,
                        buttonHeight: SizeConfig.screenHeight * 0.08,
                        // buttonWidth: 160,
                        buttonWidth: SizeConfig.screenWidth ,
                        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: kTextColor,
                          ),
                          color: Colors.white,
                        ),
                        buttonElevation: 2,
                        itemHeight: 40,
                        itemPadding: const EdgeInsets.only(left: 15, right: 15),
                        dropdownMaxHeight: 209,
                        dropdownWidth: SizeConfig.screenWidth ,
                        dropdownPadding: null,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        dropdownElevation: 8,
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        offset: const Offset(-20, 0),
                      ),
                    ),

                      SizedBox(height: SizeConfig.screenHeight * 0.3),
                      DefaultButton(
                        text: "Add new Service",
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            addService();
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
}

class Emp {
  String price;
  String name;
  String category;

  Emp(
      this.price,
      this.name,
      this.category,
      );
}