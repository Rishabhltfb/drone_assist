import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

import 'package:drone_assist/src/models/checklist_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChecklistService {
  Future<bool> postEvent(Map<String, dynamic> data) async {
    await _firestore.collection("/events").add(data).then((value) {
      print(value);
    });
    return true;
  }

  Future<List<CheckList>> fetchCheckLists() async {
    List<CheckList> list = [];

    await _firestore
        .collection("/events")
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        list.add(CheckList.fromMap(element.data()));
      });
    });
    return list;
  }
}
