import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyImage {
  String id;
  final String name;
  final String path;
  final String userName;
  final String description;
  final List<String> tags;
  late bool deleted;

  static CollectionReference dbImages = FirebaseFirestore.instance.collection('images');

  MyImage({
    this.id = '',
    required this.name,
    this.path = '',
    required this.userName,
    this.description = '', 
    this.tags = const ['foryou'],
    this.deleted = false,
  });

  Future<void> createImage() {
    final imageDoc = dbImages.doc();
    id = imageDoc.id;
    final imageData = toJson();
    // Call the user's CollectionReference to add a new user
    return imageDoc.set(imageData)
        .then((value) => print("Image Added"))
        .catchError((error) => print("Failed to add image: $error"));
  }

  static Future<String> getImageUrlFromFirestore({required String imageName}) async {
    return await FirebaseStorage.instance.ref().child(imageName).getDownloadURL();
  }

  static Stream<List<MyImage>> readImages() => FirebaseFirestore.instance
    .collection('images')
    .snapshots()
    .map((snapshot) => snapshot.docs.map(
      (doc) => MyImage.fromJson(doc.data()))
    .toList()
    );

  static Future<MyImage?> readImage({required String? id}) async {
    final docUser = FirebaseFirestore.instance.collection('images').doc(id);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return MyImage.fromJson(snapshot.data()!);
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': path,
    'user_name': userName,
    'description': description,
    'tags': tags,
    'deleted': deleted,
  };
  static MyImage fromJson(Map<String,dynamic> json) => MyImage(
    id: json['id'], 
    name: json['name'],
    userName: json['user_name'], 
    description: json['description'],
    tags: List<String>.from(json['tags']),
    deleted: json['deleted']
  );
}