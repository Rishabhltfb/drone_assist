import 'package:drone_assist/src/helper/dimensions.dart';
import 'package:drone_assist/src/models/user_model.dart';
import 'package:drone_assist/src/providers/user_provider.dart';
import 'package:drone_assist/src/services/checklist_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateChecklistScreen extends StatefulWidget {
  const CreateChecklistScreen({Key? key}) : super(key: key);

  @override
  _CreateChecklistScreenState createState() => _CreateChecklistScreenState();
}

class _CreateChecklistScreenState extends State<CreateChecklistScreen> {
  late double vpH, vpW;
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<List<String>> checkpointList = ValueNotifier<List<String>>([]);
  ValueNotifier<String> currCheckpoint = ValueNotifier<String>("");
  TextEditingController checkPointController = new TextEditingController();

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
            _formKey.currentState!.save();
            data['checkpoints'] = checkpointList.value;
            AppUser user = Provider.of<UserProvider>(context, listen: false).getUser;
            data['userid'] = user.uid;
            ChecklistService().postCheckList(data).then((success) {
              if (success) {
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Unable to Create CheckList. Try Again!')),
                );
              }
            });
          }
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
          primary: true,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
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
                      TextFormField(
                        initialValue: data["title"],
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter the title for checklist',
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          setState(() {
                            data['title'] = newValue;
                          });
                        },
                      ),
                      TextFormField(
                        initialValue: data["description"],
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter the description for checklist',
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          setState(() {
                            data['description'] = newValue;
                          });
                        },
                      ),
                      ValueListenableBuilder(
                        valueListenable: checkpointList,
                        builder: (context, value, child) => ListView.builder(
                          primary: false,
                          itemCount: checkpointList.value.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String checkpoint = checkpointList.value[index];
                            return ListTile(
                              title: Text(checkpoint),
                              leading: Text((index + 1).toString()),
                              trailing: IconButton(
                                  onPressed: () {
                                    checkpointList.value =
                                        List.from(checkpointList.value)
                                          ..removeWhere((element) {
                                            return element == checkpoint;
                                          });
                                  },
                                  icon: Icon(Icons.delete)),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: checkPointController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.person),
                                hintText: 'Add new checkpoint',
                                labelText: 'Checkpoint',
                              ),
                              onChanged: (value) {
                                currCheckpoint.value = value;
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder(
                              valueListenable: currCheckpoint,
                              builder: (context, value, child) => IconButton(
                                  onPressed: () {
                                    if (currCheckpoint.value.isNotEmpty) {
                                      checkpointList.value =
                                          List.from(checkpointList.value)
                                            ..add(currCheckpoint.value);
                                      print("Added checkpoint");
                                      currCheckpoint.value = "";
                                      checkPointController.clear();
                                    } else {
                                      print("In else block");
                                    }
                                  },
                                  icon: Icon(Icons.add)),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 45),
                        child: _button("Create CheckList", context, vpH),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    checkpointList.dispose();

    super.dispose();
  }
}
