import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylle/services/auth/auth_user.dart';
import 'package:stylle/utilities/check_connectivity.dart';

class Logging {
  String uid;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime time;

  static CollectionReference dbLogging =
      FirebaseFirestore.instance.collection('logging');

  Logging({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'time': Timestamp.fromDate(time),
      };

  static Logging fromJson(Map<String, dynamic> json) {
    DateTime parseTime(dynamic timeField) {
      if (timeField is Timestamp) {
        return timeField.toDate();
      } else if (timeField is String) {
        return DateTime.parse(timeField);
      } else {
        throw ArgumentError('Invalid time field type');
      }
    }

    return Logging(
      uid: json['uid'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      time: parseTime(json['time']),
    );
  }

  Future<void> addLogging() async {
    if (!(await checkInternetConnectivity())) {
      displayNoInternet();
      return;
    }
    final logging = toJson();
    return dbLogging
        .add(logging)
        .then((value) => print("Add logging!"))
        .catchError((error) => print("Failed to add logging: $error"));
  }

  Future<void> readLogging() {
    return dbLogging.doc().get();
  }

  static Future<List<Logging>> loggingFuture() async {
    final snapshot = await dbLogging.get(); // Đợi kết quả của Future
    return snapshot.docs
        .map((doc) => Logging.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}





  // Future<void> createUser() async {
  //   if (!(await checkInternetConnectivity())) {
  //     displayNoInternet();
  //     return;
  //   }
  //   final userData = toJson();
  //   // Call the user's CollectionReference to add a new user
  //   return dbUsers
  //       .doc(uid)
  //       .set(userData)
  //       .then((value) => print("User Added"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

  // static Stream<List<MyUser>> readUsers() => FirebaseFirestore.instance
  //     .collection('users')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => MyUser.fromJson(doc.data())).toList());

  // static Future<MyUser?> readUser({required String? uid}) async {
  //   final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  //   final snapshot = await docUser.get();

  //   if (snapshot.exists) {
  //     return MyUser.fromJson(snapshot.data()!);
  //   } else {
  //     return null;
  //   }
  // }
