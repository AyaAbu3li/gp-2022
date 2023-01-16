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
import 'package:dropdown_button2/dropdown_button2.dart';
import 'services.dart';


class editService extends StatefulWidget {
  final String text;
  const editService(this.text);
  @override
  State<editService> createState() => _editServiceState();
}

class _editServiceState extends State<editService> {
  final _formKey = GlobalKey<FormState>();
  _editServiceState(){
    // valueChoose= listItem[0];
  }
  Salon salon = Salon('','','','','','','','','','','','');
  List<Category> cate = [];

  bool circular = true;
  String errorNameImg ="assets/icons/white.svg";
  String namme ='';
  String valueChoose = "MAKEUP";
  List<String> listItem = [];
  Emp em = Emp('','','');
  List<Servicee> serviceee = [];


  @override
  void initState() {
    super.initState();
    getService();
  }

  void delete() async {

    try{

      var res45 = await http.get(Uri.parse("http://"+ip+":3000/salon"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      var decoded = json.decode(res45.body);
      setState(() {
        decoded = json.decode(res45.body);
        salon.email = decoded['email'];
      });

      var res = await http.delete(Uri.parse("http://"+ip+":3000/services/"+widget.text),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
          });
      var res4 = await http.get(
        Uri.parse("http://" + ip + ":3000/services/" + salon.email),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
        },
      );
      var ser = json.decode(res4.body);
      setState(() {
        this.serviceee = ser.map<Servicee>(Servicee.fromJson).toList();
        serviceee.removeWhere((data) => data.category != em.category);
      });
      if(serviceee.isEmpty){
        var resss = await http.delete(Uri.parse("http://"+ip+":3000/category/"+
            salon.email+"/"+em.category),
            headers: <String, String>{
              'Context-Type': 'application/json;charSet=UTF-8',
            });
      }

      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Deleted'),
              content: Text("Service has been successfully removed"),
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const services(),
                        )
                        )
                  // Navigator.pop(context),
                ),
              ],
            ),
      );
    } catch(e){
      print(" delete");
      print(e);
    }
  }
  void edit() async {

    try{
      var res = await http.patch(Uri.parse("http://"+ip+":3000/services/"+widget.text),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
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
              title: Text('modified'),
              content: Text("Service has been successfully modified"),
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const services(),
                      )
                      )
                      // Navigator.pop(context),
                ),
              ],
            ),
      );
    } catch(e){
      print(" edit");
      print(e);
    }
  }
  void getService() async {
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
  var data;
  try{
    var res = await http.get(Uri.parse("http://"+ip+":3000/service/"+widget.text),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
      },
    );
    data = json.decode(res.body);
    setState(() {
      valueChoose = data['category'];
      em.category = data['category'];
      em.price = data['price'].toString();
      em.name = data['name'];
      circular = false;
    });
  } catch(e){
    print(" get service");
    print(e);
  }
}

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Edit Service')),
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
                      Row(children: [
                        Text('Service Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        initialValue: em.name,
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
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      Row(children: [
                        Text('Service Price',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        initialValue: em.price,
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
                        // Row(
                          // children: const [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.purple,
                            ),
                            // SizedBox(width: 4),
                        //     Expanded(
                        //       child: Text(
                        //         'Select Category',
                        //         style: TextStyle(
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.yellow,
                        //         ),
                        //         overflow: TextOverflow.ellipsis,
                        //       ),
                        //     ),
                        //   ],
                        // ),
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

                      SizedBox(height: SizeConfig.screenHeight * 0.1),
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
                      SizedBox(height: SizeConfig.screenHeight * 0.05),

                      DefaultButton(
                        text: "Edit Service",
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            edit();
                          }
                        },
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(56),
                        child:
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            delete();
                          },
                          child: Text('Delete Service',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              color: Colors.white,),

                          ),
                        ),
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