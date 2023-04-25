import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String firstName;
  final String uid;
  final String lastName;
  final String email;
  static CollectionReference dbUsers = FirebaseFirestore.instance.collection('users');

  MyUser(this.uid, this.firstName, this.lastName, this.email, );


  Future<void> addUser() {
    final userData = {
      'first_name':firstName,
      'last_name':lastName,
      'email':email,
    };
    // Call the user's CollectionReference to add a new user
    return dbUsers.doc(uid).set(userData)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<String?> getUserFirstNameById({required String? uid}) async {
    try {
      final dbusers = dbUsers.doc(uid).get();
      QuerySnapshot snapshot = await dbUsers.limit(1).get();
      return snapshot.docs[0]["first_name"];
    } catch (e) {
      print(e);
    }
  }
}