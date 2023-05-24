import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stylle/services/collections/my_users.dart';

class MyImage {
  String id;
  String path;
  final DateTime uploadTime;
  final String name;
  final String userName;
  final String userEmail;
  final String userID;
  final String userProfilePic;
  final String description;
  final List<String> tags;
  int likes;
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
    required this.path,
    required this.name,
    required this.uploadTime,
    required this.userName,
    required this.userEmail, 
    required this.userID, 
    required this.userProfilePic,
    this.description = '', 
    this.tags = const ['foryou'],
    this.likes = 0,
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
        imageList.add(MyImage.fromJson(documentSnapshot.data()));
      }
      imagesStreamController.add(imageList);
    });
   }

  static Stream<List<MyImage>> imagesStream() => 
    FirebaseFirestore.instance.collection('images')
    .snapshots().map((snapshot) => snapshot.docs.map((doc) => MyImage.fromJson(doc.data())).toList());

  bool isUserFavorite(MyUser user) {
    for (var imageID in user.favorites) { 
      if (id == imageID) {
        return true;
      }
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'user_name': userName,
    'description': description,
    'tags': tags,
    'upload_time': uploadTime,
    'download_url': path,
    'likes': likes,
    'user_info': {
      'name': userName,
      'email': userEmail,
      'id': userID,
      'profile': userProfilePic,
    },
    'deleted': deleted,
  };
  static MyImage fromJson(Map<String,dynamic> json) {
    try {
      return MyImage(
        id: json['id'], 
        name: json['name'],
        userName: json['user_info']['name'], 
        userEmail: json['user_info']['email'], 
        userID: json['user_info']['id'], 
        userProfilePic: json['user_info']['profile'], 
        description: json['description'],
        tags: List<String>.from(json['tags']),
        uploadTime: DateTime.parse(json['upload_time'].toDate().toString()),
        path: json['download_url'], 
        likes: json['likes'],
        deleted: json['deleted'], 
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}