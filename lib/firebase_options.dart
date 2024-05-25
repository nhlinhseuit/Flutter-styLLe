// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAho-6DqCZT50Q8fq3fQuW0xb_DsVYrEWw',
    appId: '1:1024287017546:web:9f0d49eab135b1f29134b3',
    messagingSenderId: '1024287017546',
    projectId: 'stylle',
    authDomain: 'stylle.firebaseapp.com',
    storageBucket: 'stylle.appspot.com',
    measurementId: 'G-991W3986NV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpKPaEwroREo5oM9ZhLwuWnGRz6oFRKvc',
    appId: '1:1024287017546:android:2e46256e8a7936039134b3',
    messagingSenderId: '1024287017546',
    projectId: 'stylle',
    storageBucket: 'stylle.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyACqA-Q9txJOxxp9tqQFq0qu9D-eNuZy2E',
    appId: '1:1024287017546:ios:eae66c299d34469d9134b3',
    messagingSenderId: '1024287017546',
    projectId: 'stylle',
    storageBucket: 'stylle.appspot.com',
    androidClientId: '1024287017546-0on50bvpdiktae3vlb30hrbq6998quqf.apps.googleusercontent.com',
    iosClientId: '1024287017546-gr4bij46rs6t64ci5v8e45rgfvijp2eu.apps.googleusercontent.com',
    iosBundleId: 'com.uit.stylle',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyACqA-Q9txJOxxp9tqQFq0qu9D-eNuZy2E',
    appId: '1:1024287017546:ios:eae66c299d34469d9134b3',
    messagingSenderId: '1024287017546',
    projectId: 'stylle',
    storageBucket: 'stylle.appspot.com',
    androidClientId: '1024287017546-0on50bvpdiktae3vlb30hrbq6998quqf.apps.googleusercontent.com',
    iosClientId: '1024287017546-gr4bij46rs6t64ci5v8e45rgfvijp2eu.apps.googleusercontent.com',
    iosBundleId: 'com.uit.stylle',
  );
}
