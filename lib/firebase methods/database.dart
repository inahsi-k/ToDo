import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDatabase {
  FirebaseFirestore fire = FirebaseFirestore.instance;
  String get user => FirebaseAuth.instance.currentUser!.uid;
  String? lastAddedDocId;

  //create
  Future<void> addData({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool isChecked, /** */
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }
    await fire
        .collection('todo')
        .doc(user)
        .collection('user_todos')
        .add({
          "title": title,
          "description": description,
          "startDate": startDate,
          "endDate": endDate,
          "isChecked":isChecked, /** */
          "createdAt": DateTime.now(),
        });
    
  }

  //Read
  Stream<QuerySnapshot> getData() {
    return fire
        .collection('todo')
        .doc(user)
        .collection('user_todos')
        .snapshots();
  }

  //Update
  Future<void> updateData({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool isChecked, /** */
    required String docId,
  }) async {
    await fire
        .collection('todo')
        .doc(user)
        .collection('user_todos')
        .doc(docId)
        .update({
          "title": title,
          "description": description,
          "startDate": startDate,
          "isChecked":isChecked, /** */
          "endDate": endDate,
        });
  }

  //Delete
  Future<void> deleteData({required String docId}) async {
    await fire
        .collection('todo')
        .doc(user)
        .collection('user_todos')
        .doc(docId)
        .delete();
  }
}
