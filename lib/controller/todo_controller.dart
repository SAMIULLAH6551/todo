import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todo/extentions/extentions.dart';
import 'package:todo/utils/message_box.dart';

class TodoController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  Utils utils = Utils();

  // Stream should not be in Future
  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    return firestore
        .collection('Todo')
        .where("Uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  void addNote(String title , description){
    firestore.collection('Todo').doc(id).set({
      "Uid" : auth.currentUser!.uid.toString(),
      "ProductId" : id.toString(),
      "Title" : title.toString(),
      "Description" : description.toString(),
      "CreationDate" : DateTime.now().customDate(),
      "Completed" : false
    }).then((value){
      utils.snackBarMessage("Success", "Todo's Added Success");
    }).onError((error, stackTrace){
      utils.snackBarMessage("Error", error.toString());
    });
  }


  void deleteNote(String doc){
  firestore.collection('Todo').doc(doc).delete().then((value){
    utils.snackBarMessage("Delete", "Note Deleted Success");
  }).onError((error, stackTrace){
    utils.snackBarMessage("Error", error.toString());
  });
  }

  void updateNoteStatus(String doc,bool status){
    firestore.collection('Todo').doc(doc).update({
      "Completed" : status,
    }).then((value){
      utils.snackBarMessage("Update", "Status Update Success");
    }).onError((error, stackTrace){
      utils.snackBarMessage("Error", error.toString());
    });
  }

  Stream<QuerySnapshot<Map<String,dynamic>>> getTodayTodo(){
    return firestore.collection("Todo").where("CreationDate",isEqualTo: DateTime.now().customDate()).where('Uid',isEqualTo:auth.currentUser!.uid.toString()).snapshots();
  }
}
