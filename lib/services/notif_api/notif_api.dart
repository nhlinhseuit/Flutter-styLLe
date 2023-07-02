import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMsg(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}

class NotifAPI {
  final _firebaseMsg = FirebaseMessaging.instance;

  Future<void> init() async {
    await _firebaseMsg.requestPermission();
    final fCMToken = await _firebaseMsg.getToken();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMsg);
  }

  Future<String?> getFCMToken() async {
    return await _firebaseMsg.getToken();
  }
}
