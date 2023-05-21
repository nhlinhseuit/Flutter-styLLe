import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/collections/my_images.dart';

class MyUser {
  final String firstName;
  final String uid;
  final String lastName;
  final String email;
  final String profileImage;
  final List<MyImage> favorites;
  late bool deleted;

  static CollectionReference dbUsers = FirebaseFirestore.instance.collection('users');
  
  MyUser({
    this.profileImage = "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
    this.favorites = const [],  
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,

    this.deleted = false,
  });

  static Future<MyUser?> getCurrentUser() async {
    return await readUser(uid: AuthService.firebase().currentUser?.uid);
  }

  String get getName {
    return "$firstName $lastName";
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

  void addFavoriteImage(MyImage image) {
    if (image.isUserFavorite(this)) return;
    favorites.add(image);
    FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .update({
        'favorites': favorites.map((image) => image.toJson())
      })
      .catchError((error) => print("Failed to add fav image: $error"));
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'profile_image': profileImage,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'favorites': favorites.map((image) => image.toJson()),
    'deleted': deleted,
  };
  static MyUser fromJson(Map<String,dynamic> json) => MyUser(
    uid: json['uid'], 
    profileImage: json['profile_image'],
    firstName: json['first_name'], 
    lastName: json['last_name'], 
    email: json['email'],
    favorites: List<MyImage>.from(json['favorites'].map((doc) {
      return MyImage.fromJson(doc);
    })),
    deleted: json['deleted'],
  );
}

