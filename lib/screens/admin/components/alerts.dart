import 'package:flutter/material.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class alert extends StatefulWidget {
  const alert({Key? key}) : super(key: key);
  @override
  State<alert> createState() => _alertState();
}

class _alertState extends State<alert> {
  final _formKey = GlobalKey<FormState>();
  Emp em = Emp('','');

  String errorNameImg ="assets/icons/white.svg";
  String namme ='';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Alerts'),
    ),
    body: SafeArea(
      child: SizedBox(
      width: double.infinity,
        child: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              TextFormField(
                onChanged: (value) {
                  em.name = value;
                },
                validator: (Name) {
                  if (Name == null || Name.isEmpty) {
                    setState(() {
                      errorNameImg = "assets/icons/Error.svg";
                      namme = 'Please enter Alert details';
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
                  labelText: 'Alert title',
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.02),

              TextFormField(
                onChanged: (value) {
                  em.details = value;
                },
                validator: (Name) {
                  if (Name == null || Name.isEmpty) {
                    setState(() {
                      errorNameImg = "assets/icons/Error.svg";
                      namme = 'Please enter Alert details';
                    });
                    return "";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.add_alert,
                    color: Colors.purple ,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: 'Alert details',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                minLines: 3,
                maxLines: null,
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.03),
              DefaultButton(
                text: "Send",
                press: () {
                  if (_formKey.currentState!.validate()) {
                    // Do what you want to do
                  }
                },
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
            ]
            ),
          ),
        ),
      ),
    ),
  );
}
class Emp {
  String name;
  String details;

  Emp(
      this.name,
      this.details,);
}