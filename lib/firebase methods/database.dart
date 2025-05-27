import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDatabase {
  FirebaseFirestore fire = FirebaseFirestore.instance;

  String get user => FirebaseAuth.instance.currentUser!.uid;

  Future<void> addData({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await fire.collection('todo').doc(user).collection('user_todos').add({
      "title": title,
      "description": description,
      "startdate": startDate,
      "enddate": endDate,
      "createdAt": DateTime.now(),
    });
  }

  Stream<QuerySnapshot> getData() {
    return fire.collection('todo').doc(user).collection('user_todos').snapshots();
  }

  

}
