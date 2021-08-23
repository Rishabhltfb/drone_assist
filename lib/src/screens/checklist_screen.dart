import 'package:drone_assist/src/helper/dimensions.dart';
import 'package:drone_assist/src/models/checklist_model.dart';
import 'package:drone_assist/src/screens/tts_screen.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
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
                  widget.checkList.title,
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
                      Text(widget.checkList.checkpoints.length.toString() +
                          "    Total Checkpoints"),
                    ],
                  ),
                ),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: widget.checkList.checkpoints.length,
                  itemBuilder: (context, index) {
                    String checkPoint = widget.checkList.checkpoints[index];
                    // String id = widget.checkList.id;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8),
                      child: PhysicalModel(
                        color: Colors.white,
                        shadowColor: Colors.blue.withOpacity(0.3),
                        elevation: 2.0,
                        child: ListTile(
                          tileColor: Colors.white,
                          title: Text(checkPoint),
                          onLongPress: () {
                            // showDeleteDialog(context, checkPoint, id);
                          },
                          onTap: () {
                            currIndex.value = currIndex.value + 1;
                          },
                          trailing: ValueListenableBuilder(
                            valueListenable: currIndex,
                            builder: (context, value, child) => Icon(
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return TTSScreen();
                          },
                        ));
                        // print("Button pressed");
                        // start.value = true;
                        // currIndex.value = currIndex.value + 1;
                      },
                      child: Text(start.value ? "Resume" : "Start"))),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    currIndex.dispose();
    super.dispose();
  }
}
