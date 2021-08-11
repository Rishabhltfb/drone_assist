import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

import 'package:drone_assist/src/models/checklist_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChecklistService {
  Future<bool> postCheckList(Map<String, dynamic> data) async {
    String docId = DateTime.now().toIso8601String();
    data["id"] = docId;
    await _firestore.collection("/checklists").doc(docId).set(data).then((_) {
      print("Checklist set Successfully");
    }).onError((error, stackTrace) {
      print("Error while Posting Checklist: $error");
    });
    return true;
  }

  Future<List<CheckList>> fetchCheckLists() async {
    List<CheckList> list = [];
    await _firestore
        .collection("/checklists")
        .orderBy('priority', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        list.add(CheckList.fromMap(element.data()));
      });
    }).onError((error, stackTrace) {
      print("Error while fetching checklists: $error");
    });
    return list;
  }
}
