import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/collections/logging.dart';
import 'package:stylle/services/collections/my_images.dart';

import '../../utilities/check_connectivity.dart';
import '../../utilities/commons.dart';

class MyUser {
  final String uid;
  final String email;
  String firstName;
  String lastName;
  String profileImage;
  List<String> favorites;
  List<String> reports;
  late bool deleted;
  String role;

  static CollectionReference dbUsers =
      FirebaseFirestore.instance.collection('users');

  MyUser({
    this.profileImage =
        "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
    this.role = 'none',
    this.favorites = const [],
    this.reports = const [],
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.deleted = false,
  });

  Future<void> updateInfo({String? firstName, String? lastName}) async {
    if (!(await checkInternetConnectivity())) {
      displayNoInternet();
      return;
    }
    if ((firstName == null || firstName.isEmpty) &&
        (lastName == null || lastName.isEmpty)) {
      return;
    }
    firstName = firstName == null || firstName.isEmpty
        ? this.firstName
        : firstName.trim();
    lastName =
        lastName == null || lastName.isEmpty ? this.lastName : lastName.trim();
    this.firstName = firstName;
    this.lastName = lastName;

    // update thông tin user
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'first_name': firstName,
      'last_name': lastName,
    }).catchError((error) => print("Failed to update info: $error"));

    // update thông tin user trong thông tin của các image
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('images')
        .where('user_info.id', isEqualTo: uid)
        .get();

    querySnapshot.docs.forEach((DocumentSnapshot doc) async {
      DocumentReference documentRef = doc.reference;
      try {
        await documentRef.update({
          'user_info.name': getName,
        });
      } catch (error) {
        print('Error updating document: $error');
      }
    });
  }

  static Future<MyUser?> getCurrentUser() async {
    final googleUser =
        await readUser(uid: AuthService.google().currentUser?.uid);
    if (googleUser != null) {
      return googleUser;
    }
    return await readUser(uid: AuthService.firebase().currentUser?.uid);
  }

  String get getName {
    return "$firstName $lastName";
  }

  Future<void> createUser() async {
    if (!(await checkInternetConnectivity())) {
      displayNoInternet();
      return;
    }
    final userData = toJson();
    // Call the user's CollectionReference to add a new user
    // return dbUsers
    //     .doc(uid)
    //     .set(userData)
    //     .then((value) => print("User Added"))
    //     .catchError((error) => print("Failed to add user: $error"));
    
    Logging logger = Logging(
        uid: uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        time: DateTime.now(),
        type: LoggingType.register);
    await logger.addLogging();
    return dbUsers
        .doc(uid)
        .set(userData)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Stream<List<MyUser>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => MyUser.fromJson(doc.data())).toList());

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
    image.isFavorite = true;
    image.likes++;
    await FirebaseFirestore.instance.collection('images').doc(image.id).update({
      'likes': image.likes,
    });
    favorites.add(image.id);
    // image.isFavorite = false;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'favorites': favorites.isNotEmpty ? favorites : []
    }).catchError((error) => print("Failed to add fav image: $error"));
  }

  Future<void> removeFavoriteImage(MyImage image) async {
    if (!image.isUserFavorite(this) || image.likes == 0) return;
    image.isFavorite = false;
    image.likes--;
    await FirebaseFirestore.instance.collection('images').doc(image.id).update({
      'likes': image.likes,
    });
    favorites.remove(image.id);
    // image.isFavorite = false;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'favorites': favorites.isNotEmpty ? favorites : []
    }).catchError((error) => print("Failed to remove fav image: $error"));
  }

  Future<void> handleFavorite(MyImage image) async {
    if (!(await checkInternetConnectivity())) {
      displayNoInternet();
      return;
    }
    if (image.isUserFavorite(this)) {
      await removeFavoriteImage(image);
    } else {
      await addFavoriteImage(image);
    }
  }

  Future<void> addReportImage(MyImage image) async {
    if (image.isUserReport(this)) return;
    image.isReport = true;
    image.dislikes++;
    await FirebaseFirestore.instance.collection('images').doc(image.id).update({
      'dislikes': image.dislikes,
    });
    reports.add(image.id);
    // image.isFavorite = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'reports': reports.isNotEmpty ? reports : []}).catchError(
            (error) => print("Failed to add report image: $error"));
  }

  Future<void> removeReportImage(MyImage image) async {
    if (!image.isUserReport(this) || image.dislikes == 0) return;
    image.isReport = false;
    image.dislikes--;
    await FirebaseFirestore.instance.collection('images').doc(image.id).update({
      'dislikes': image.dislikes,
    });
    reports.remove(image.id);
    // image.isFavorite = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'reports': reports.isNotEmpty ? reports : []}).catchError(
            (error) => print("Failed to remove report image: $error"));
  }

  Future<void> handleReport(MyImage image) async {
    if (!(await checkInternetConnectivity())) {
      displayNoInternet();
      return;
    }
    if (image.isUserReport(this)) {
      await removeReportImage(image);
    } else {
      await addReportImage(image);
    }
  }

  Stream<List<MyImage>> favoriteImagesStream() {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('images');
    const chunkSize = 10;

    final baseQuery = collection
        .where('deleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MyImage.fromJson(doc.data())).toList());

    if (favorites.isNotEmpty) {
      final chunks = chunkList(favorites, chunkSize);

      final streamGroup = StreamGroup<List<MyImage>>();

      for (final chunk in chunks) {
        final chunkQuery = collection
            .where('deleted', isEqualTo: false)
            .where('id', whereIn: chunk)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => MyImage.fromJson(doc.data()))
                .toList());
        streamGroup.add(chunkQuery);
      }

      final mergedList = <MyImage>[];
      return streamGroup.stream.map((results) {
        mergedList.addAll(results);

        return mergedList;
      });
    }

    return baseQuery;

    // if (favorites.isNotEmpty) {
    //   final chunks = chunkList(favorites, chunkSize);
    //   final streamGroup = StreamGroup<List<MyImage>>();

    //   for (final chunk in chunks) {
    //     final chunkQuery = collection
    //         .where('deleted', isEqualTo: false)
    //         .where('id', whereIn: chunk)
    //         .snapshots()
    //         .map((snapshot) => snapshot.docs
    //             .map((doc) => MyImage.fromJson(doc.data()))
    //             .toList());
    //     streamGroup.add(chunkQuery);
    //   }
    //   return streamGroup.stream;
    // }
    // return collection.where('deleted', isEqualTo: false).snapshots().map(
    //     (snapshot) =>
    //         snapshot.docs.map((doc) => MyImage.fromJson(doc.data())).toList());
  }

  Stream<List<MyImage>> userImagesStream() => FirebaseFirestore.instance
      .collection('images')
      .where('deleted', isEqualTo: false)
      .where('user_info.id', isEqualTo: uid)
      .orderBy('upload_time', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => MyImage.fromJson(doc.data())).toList());

  
  
  Future<int> update(
    Map<String, dynamic> updateData,
  ) async {
    await dbUsers.doc(uid).update(updateData);
    return 1;
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'profile_image': profileImage,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'favorites': favorites,
        'deleted': deleted,
      };
  static MyUser fromJson(Map<String, dynamic> json) => MyUser(
        uid: json['uid'],
        role: json['role'] ?? 'none',
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
