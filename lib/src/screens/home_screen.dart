import 'package:drone_assist/src/dialogs/delete_dialog.dart';
import 'package:drone_assist/src/helper/dimensions.dart';
import 'package:drone_assist/src/models/checklist_model.dart';
import 'package:drone_assist/src/providers/checklist_provider.dart';
import 'package:drone_assist/src/screens/auth_screen.dart';
import 'package:drone_assist/src/screens/checklist_screen.dart';
import 'package:drone_assist/src/screens/create_cheklist_screen.dart';
import 'package:drone_assist/src/services/auth_service.dart';
import 'package:drone_assist/src/services/checklist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double vpH, vpW;
  ValueNotifier<List<CheckList>> checkList = ValueNotifier<List<CheckList>>([]);

  void fetchCheckList() {
    ChecklistService().fetchCheckLists().then((fetchedList) {
      Provider.of<ChecklistProvider>(context, listen: false).setChecklists =
          fetchedList;
    });
  }

  @override
  void dispose() {
    checkList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    fetchCheckList();

    checkList.value = Provider.of<ChecklistProvider>(context).getChecklists;
    // dummyChecklist.forEach((element) {
    //   checkList.value.add(CheckList.fromMap(element));
    // });
    return SafeArea(
      child: Scaffold(
        body: Scrollbar(
          interactive: true,
          thickness: 10,
          child: SingleChildScrollView(
            primary: true,
            child: ValueListenableBuilder(
              valueListenable: checkList,
              builder: (context, value, child) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {});
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) {
                            //     return ProfileScreen();
                            //   },
                            // ));
                          },
                          icon: Icon(
                            Icons.account_circle_outlined,
                            size: vpW * 0.1,
                          )),
                      IconButton(
                          onPressed: () {
                            AuthService().signOutGoogle();
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) {
                                return AuthScreen();
                              },
                            ));
                          },
                          icon: Icon(Icons.logout)),
                    ],
                  ),
                  Container(
                    width: vpW,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/illustrations/checklist.svg',
                              height: vpH * 0.2,
                              width: vpW * 0.2,
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "CHECKLISTS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: vpW * 0.08,
                          ),
                        ),
                      ],
                    ),
                  ),
                  checkList.value.length == 0
                      ? Container(
                          height: vpH * 0.5,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset(
                                'assets/illustrations/empty.svg',
                                height: vpH * 0.2,
                                width: vpW * 0.2,
                              ),
                              Text(
                                "Opps! Looks like there \nis no checklist yet.",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ))
                      : ListView.builder(
                          itemCount: checkList.value.length,
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            CheckList currCheckList = checkList.value[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8),
                              child: PhysicalModel(
                                color: Colors.white,
                                shadowColor: Colors.blue.withOpacity(0.3),
                                elevation: 2.0,
                                child: ListTile(
                                  tileColor: Colors.white,
                                  title: Text(currCheckList.title),
                                  subtitle: Text(currCheckList.description),
                                  onLongPress: () {
                                    showDeleteDialog(context,
                                        currCheckList.title, currCheckList.id);
                                  },
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return CheckListScreen(
                                            checkList: checkList.value[index]);
                                      },
                                    ));
                                  },
                                  trailing: Icon(Icons.checklist_outlined),
                                ),
                              ),
                            );
                          },
                        )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return CreateChecklistScreen();
              },
            ));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
