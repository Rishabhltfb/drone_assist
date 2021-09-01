import 'dart:async';

import 'package:drone_assist/src/helper/dimensions.dart';
import 'package:drone_assist/src/models/checklist_model.dart';
import 'package:drone_assist/src/models/user_model.dart';
import 'package:drone_assist/src/providers/user_provider.dart';
import 'package:drone_assist/src/services/stt_service.dart';
import 'package:drone_assist/src/services/tts_service.dart';
import 'package:drone_assist/src/utils/speech_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckListScreen extends StatefulWidget {
  final CheckList checkList;
  const CheckListScreen({Key? key, required this.checkList}) : super(key: key);

  @override
  _CheckListScreenState createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  ValueNotifier<int> currIndex = ValueNotifier<int>(0);
  late double vpH, vpW;
  ValueNotifier<bool> start = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isListening = ValueNotifier<bool>(false);
  TTSService ttsService = TTSService();
  SpeechApi sttService = SpeechApi();
  String name = "User";

  // For STT Service

  String _text = "";
  // double _confidence = 1.0;

  bool available = false;

  @override
  void initState() {
    AppUser appUser = Provider.of<UserProvider>(context, listen: false).getUser;
    name = appUser.name.isNotEmpty ? appUser.name : "User";
    super.initState();
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) {
          setState(() {
            // print("result from onResult is $text");
            this._text = text;
          });
        },
        onListening: (value) async {
          if (_isListening.value && !value) {
    print("Step3");
            print("Listening is complete by the api: ${this._text}");
            await ttsService.speak("Analysing response").whenComplete(() async {
    print("Step4");
              bool res;
              res = interpretResponse(this._text);
              print("res of interpreter is : $res");
              if (res) {
    print("Step5");
                if (currIndex.value !=
                    widget.checkList.checkpoints.length - 1) {
    print("Step6");
                  currIndex.value = currIndex.value + 1;
                  await ttsService
                      .speak(
                          "Checkpoint Marked Completed. Moving forward to next checkpoint")
                      .whenComplete(() => _listen());
                } else {
    print("Step6-");
                  print("In else block for currIndex");
                  // TODO: launch end checkpoint callback
                }
              } else {
    print("Step5-");
                ttsService.speak(
                    "It seems not to be done yet! Let's try again after 10 seconds.");
                Timer(Duration(seconds: 10), _listen);
              }
            });
          }
          this._isListening.value = value;
        },
      );

  void _listen() async {
    print("Step1");
    await ttsService
        .speak("Current Checkpoint is " +
            widget.checkList.checkpoints[currIndex.value] +
            ", is it done?")
        .whenComplete(() async {
    print("Step2");
      await toggleRecording();
    });
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    CheckList checkList = widget.checkList;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        primary: true,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: vpH * 0.05,
                ),
                Text(
                  checkList.title,
                  style: TextStyle(fontSize: vpW * 0.08),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: currIndex,
                        builder: (context, value, child) => Text(
                            (currIndex.value).toString() +
                                "   Completed Checkpoints"),
                      ),
                      Text(checkList.checkpoints.length.toString() +
                          "    Total Checkpoints"),
                    ],
                  ),
                ),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: checkList.checkpoints.length,
                  itemBuilder: (context, index) {
                    String checkPoint = checkList.checkpoints[index];
                    // String id = checkList.id;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8),
                      child: PhysicalModel(
                        color: Colors.white,
                        shadowColor: Colors.blue.withOpacity(0.3),
                        elevation: 2.0,
                        child: ValueListenableBuilder(
                            valueListenable: currIndex,
                            builder: (context, value, child) =>  ListTile(
                            tileColor: Colors.white,
                            title: Text(checkPoint),
                            onLongPress: () {
                              // showDeleteDialog(context, checkPoint, id);
                            },
                            onTap: () {
                              if(currIndex.value == index){
                              _listen();
                              }
                            },
                            trailing: Icon(
                                currIndex.value == index
                                    ? Icons.play_circle_outline_rounded
                                    : (currIndex.value > index
                                        ? Icons.done_all_sharp
                                        : Icons.done),
                                color: currIndex.value == index
                                    ? Colors.yellow[600]
                                    : (currIndex.value > index
                                        ? Colors.green
                                        : Colors.grey),
                              ),
                            
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _text,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Positioned(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios))),
            ValueListenableBuilder(
              valueListenable: start,
              builder: (context, value, child) => Positioned(
                  right: 10,
                  child: OutlinedButton(
                      onPressed: () {
                        start.value = !start.value;
                        if (start.value) {
                          ttsService.speak(
                              "Hey $name ! We will be going through ${checkList.title} checklist in 5 seconds.");
                        }
                      },
                      child: Text(start.value ? "Stop" : "Start"))),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    currIndex.dispose();
    _isListening.dispose();
    start.dispose();
    super.dispose();
  }

  bool interpretResponse(String text) {
    print("Interpreting text: $text");
    List<String> words = text.toLowerCase().split(" ");
    bool positive = false;
    for (int i = 0; i < words.length && !positive; i++) {
      for (int j = 0; j < words.length; j++) {
        if (positiveResponse[i] == words[j]) {
          positive = true;
          print(positiveResponse[i] + " matched " + words[j]);
          break;
        } else {
          print(positiveResponse[i] + " Not Matched " + words[j]);
        }
      }
    }
    // print("interpret response is $positive");
    return positive;
  }
}
