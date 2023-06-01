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
  List<String> favorites;
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
    } else {
      return null;
    }
  }

  Future<void> addFavoriteImage(MyImage image) async {
    if (image.isUserFavorite(this)) return;
    image.likes++;
    await FirebaseFirestore.instance.collection('images')
      .doc(image.id)
      .update({
        'likes': image.likes,
      });
    favorites.add(image.id);
    // image.isFavorite = false;
    await FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .update({
        'favorites': favorites.isNotEmpty ? favorites : []
      })
      .catchError((error) => print("Failed to add fav image: $error"));
  }
  
  Future<void> removeFavoriteImage(MyImage image) async {
    if (!image.isUserFavorite(this) || image.likes == 0) return;
    image.likes--;
    await FirebaseFirestore.instance.collection('images')
      .doc(image.id)
      .update({
        'likes': image.likes,
      });
    favorites.remove(image.id);
    // image.isFavorite = false;
    await FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .update({
        'favorites': favorites.isNotEmpty ? favorites : []
      })
      .catchError((error) => print("Failed to remove fav image: $error"));
  }

  Future<void> handleFavorite(MyImage image) async {
    if (image.isUserFavorite(this)) {
      await removeFavoriteImage(image);
      print(1);
    } else {
      await addFavoriteImage(image);
      print(2);
    }
    print(favorites);
  }

  Stream<List<MyImage>> favoriteImagesStream() => 
  FirebaseFirestore.instance.collection('images').where('id', whereIn: favorites.isNotEmpty ? favorites : [""])
  .snapshots().map((snapshot) => snapshot.docs.map((doc) => MyImage.fromJson(doc.data())).toList());

  Stream<List<MyImage>> userImagesStream() => 
  FirebaseFirestore.instance.collection('images').where('user_id', isEqualTo: uid)
  .snapshots().map((snapshot) => snapshot.docs.map((doc) => MyImage.fromJson(doc.data())).toList());

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'profile_image': profileImage,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'favorites': favorites,
    'deleted': deleted,
  };
  static MyUser fromJson(Map<String,dynamic> json) => MyUser(
    uid: json['uid'], 
    profileImage: json['profile_image'],
    firstName: json['first_name'], 
    lastName: json['last_name'], 
    email: json['email'],
    favorites: List<String>.from(json['favorites']),
    // favorites: List<MyImage>.from(json['favorites'].map((doc) {
    //   return MyImage.fromJson(doc);
    // })),
    deleted: json['deleted'],
  );
}

