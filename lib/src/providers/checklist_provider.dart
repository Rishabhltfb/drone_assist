import 'package:drone_assist/src/models/checklist_model.dart';
import 'package:flutter/material.dart';

class ChecklistProvider extends ChangeNotifier {
  List<CheckList> _checkLists = [];

  List<CheckList> get getChecklists {
    return _checkLists;
  }

  set setChecklists(List<CheckList> checklists) {
    _checkLists = checklists;
    notifyListeners();
  }
}
