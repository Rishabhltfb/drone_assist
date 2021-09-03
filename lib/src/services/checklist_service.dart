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

  Future<bool> updateCheckList(CheckList checkList) async {
    Map<String, dynamic> data =
        checkList.toMap(checkList) as Map<String, dynamic>;
    await _firestore
        .collection("/checklists")
        .doc(data['id'])
        .update(data)
        .then((_) {
      print("Checklist updated Successfully");
    }).onError((error, stackTrace) {
      print("Error while Posting Checklist: $error");
    });
    return true;
  }

  Future<bool> deleteCheckList(String id) async {
    await _firestore.collection("/checklists").doc(id).delete().then((_) {
      print("Checklist updated Successfully");
    }).onError((error, stackTrace) {
      print("Error while Posting Checklist: $error");
    });
    return true;
  }

  Future<List<CheckList>> fetchCheckLists(String uid) async {
    List<CheckList> list = [];
    await _firestore
        .collection("/checklists").where('userid', isEqualTo: uid)
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
