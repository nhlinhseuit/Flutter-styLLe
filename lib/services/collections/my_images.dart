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
  bool isFavorite;
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
    this.isFavorite = false,
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

  Stream<List<MyImage>> getRelatedImages() {
    return FirebaseFirestore.instance.collection('images')
    .where('deleted', isEqualTo: false)
    .where(Filter.or(
      Filter('tags', arrayContainsAny: tags),
      Filter('user_info.id', isEqualTo: userID),
    ))
    .where('id', isNotEqualTo: id)
    .snapshots().map((snapshot) => snapshot.docs.map((doc) => MyImage.fromJson(doc.data())).toList())
    .handleError((e) {
      print(e);
    });
  }
  
  static Future<MyImage?> readImage({required String? id}) async {
    final docUser = FirebaseFirestore.instance.collection('images').doc(id);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return MyImage.fromJson(snapshot.data()!);
    }
    return null;
  }

  static Stream<List<MyImage>> imagesStream() => 
    FirebaseFirestore.instance.collection('images').where('deleted', isEqualTo: false).orderBy('upload_time', descending: true)
    .snapshots().map((snapshot) => snapshot.docs.map((doc) => MyImage.fromJson(doc.data())).toList());

  static Stream<List<MyImage>> imagesPopularStream() => 
    FirebaseFirestore.instance.collection('images').where('deleted', isEqualTo: false).orderBy('likes', descending: true)
    .snapshots().map((snapshot) => snapshot.docs.map((doc) => MyImage.fromJson(doc.data())).toList());


  static Stream<List<MyImage>> imagesTagsStream(List<String> tags) => 
    FirebaseFirestore.instance.collection('images').where('tags', arrayContainsAny: tags).where('deleted', isEqualTo: false)
    .snapshots().map((snapshot) => snapshot.docs.map((doc) => MyImage.fromJson(doc.data())).toList());

  static Stream<List<MyImage>> searchImages(String searchInput) {
    searchInput = searchInput.trim();
    if (searchInput.startsWith('#')) {
      searchInput.replaceFirst('#', '');
    }
    return imagesTagsStream(searchInput.split(' '));
  }

  static void readImagesStream(StreamController<List<MyImage>> imagesStreamController) {
    final imagesSnapshot = FirebaseFirestore.instance
      .collection('images').where('deleted', isEqualTo: false)
      .orderBy('upload_time', descending: true)
      .snapshots();
    imagesSnapshot.listen((querySnapshot) async { 
      final List<MyImage> imageList = [];
      for (var documentSnapshot in querySnapshot.docs) {
        imageList.add(MyImage.fromJson(documentSnapshot.data()));
      }
      imagesStreamController.add(imageList);
    });
  }

  static void readUserFavoritesStream(StreamController<List<MyImage>> imagesStreamController, MyUser user) {
    final imagesSnapshot = FirebaseFirestore.instance
      .collection('images')
      .where('deleted', isEqualTo: false)
      .where('id', whereIn: user.favorites)
      .snapshots();
    imagesSnapshot.listen((querySnapshot) async { 
      final List<MyImage> imageList = [];
      for (var documentSnapshot in querySnapshot.docs) {
        imageList.add(MyImage.fromJson(documentSnapshot.data()));
      }
      imagesStreamController.add(imageList);
    });
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance.collection('images')
      .doc(id)
      .update({
        'deleted': true,
      })
      .onError((error, stackTrace) => print(error.toString()));
  }

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