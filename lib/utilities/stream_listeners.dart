import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot> listenToImagesChanges() {
  final collectionRef = FirebaseFirestore.instance.collection('images');
  return collectionRef.snapshots();
}
Stream<QuerySnapshot> listenToUsersChanges() {
  final collectionRef = FirebaseFirestore.instance.collection('users');
  return collectionRef.snapshots();
}