import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyImage {
  String id;
  String path;
  final String name;
  final String userName;
  final String description;
  final List<String> tags;
  late bool deleted;

  String get imagePath {
    return path;
  }
  set imagePath(String path) {
    this.path = path;
  }

  static CollectionReference dbImages = FirebaseFirestore.instance.collection('images');

  MyImage({
    this.id = '',
    this.path='',
    required this.name,
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

  Future<String> getImageUrlFromFirestore() async {
    return await FirebaseStorage.instance.ref().child(name).getDownloadURL();
  }

  
  static Future<MyImage?> readImage({required String? id}) async {
    final docUser = FirebaseFirestore.instance.collection('images').doc(id);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return MyImage.fromJson(snapshot.data()!);
    }
    return null;
  }

  static Future<List<MyImage>> readImages() async {
    Query query = FirebaseFirestore.instance.collection('images');
    QuerySnapshot querySnapshot = await query.get();

    List<MyImage> images = [];
    for (var doc in querySnapshot.docs) {
      final image = MyImage.fromJson(doc.data() as Map<String,dynamic>);
      images.add(image);
    }
    return images;
  }

  static void readImagesStream(StreamController<List<MyImage>> imagesStreamController) {
    final imagesSnapshot = FirebaseFirestore.instance.collection('images').snapshots();
    imagesSnapshot.listen((querySnapshot) async { 
      final List<MyImage> imageList = [];
      for (var documentSnapshot in querySnapshot.docs) {
        final image = MyImage.fromJson(documentSnapshot.data());
        imageList.add(image);
      }
      imagesStreamController.add(imageList);
    });
  }
  static Stream<List<MyImage>> getImagesStream() {
    return FirebaseFirestore.instance.collection('images')
      .snapshots().map((snapshot) => snapshot.docs.map((doc) => 
      MyImage.fromJson(doc.data())).toList());
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'user_name': userName,
    'description': description,
    'tags': tags,
    'download_url': path,
    'deleted': deleted,
  };
  static MyImage fromJson(Map<String,dynamic> json) => MyImage(
    id: json['id'], 
    name: json['name'],
    userName: json['user_name'], 
    description: json['description'],
    path: json['download_url'],
    tags: List<String>.from(json['tags']),
    deleted: json['deleted']
  );
}