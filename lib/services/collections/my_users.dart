import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylle/services/auth/auth_service.dart';

class MyUser {
  final String firstName;
  final String uid;
  final String lastName;
  final String email;
  static CollectionReference dbUsers = FirebaseFirestore.instance.collection('users');

  MyUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  static Future<MyUser?> get currentUser async {
    return readUser(uid: AuthService.firebase().currentUser?.uid);
  }
  Future<void> createUser() {
    final userData = toJson();
    // Call the user's CollectionReference to add a new user
    return dbUsers.doc(uid).set(userData)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Stream<List<MyUser>> readUsers() => FirebaseFirestore.instance
    .collection('users')
    .snapshots()
    .map((snapshot) => snapshot.docs.map(
      (doc) => MyUser.fromJson(doc.data()))
    .toList()
    );
    

  static Future<MyUser?> readUser({required String? uid}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return MyUser.fromJson(snapshot.data()!);
    }
  }
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
  };
  static MyUser fromJson(Map<String,dynamic> json) => MyUser(
    uid: json['uid'], 
    firstName: json['first_name'], 
    lastName: json['last_name'], 
    email: json['email']
    );
}

