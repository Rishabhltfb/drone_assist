import 'package:drone_assist/src/helper/dimensions.dart';
import 'package:flutter/material.dart';

class CreateChecklistScreen extends StatefulWidget {
  const CreateChecklistScreen({Key? key}) : super(key: key);

  @override
  _CreateChecklistScreenState createState() => _CreateChecklistScreenState();
}

class _CreateChecklistScreenState extends State<CreateChecklistScreen> {
  late double vpH, vpW;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> data = {
    "title": "",
    "description": "",
    "priority": 1,
    "checkpoints": [],
  };

  Widget _button(String title, BuildContext context, double vpH) {
    return PhysicalModel(
      color: Colors.transparent,
      shadowColor: Colors.blue.withOpacity(0.3),
      borderRadius: BorderRadius.all(Radius.circular(50)),
      elevation: 8.0,
      child: FlatButton(
        color: Color(0xff2C2A2D),
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
          }
          print("CheckList Created");
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(35.0)),
        child: Text(
          title,
          style: TextStyle(fontSize: vpH * 0.03, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: vpW,
              ),
              Text(
                "Create CheckList",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: vpW * 0.065,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Add TextFormFields and ElevatedButton here.
                    TextFormField(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: _button("Create CheckList", context, vpH),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
