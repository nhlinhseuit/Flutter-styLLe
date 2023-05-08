import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String? uid;
  final String? email;
  final bool isEmailVerified;
  const AuthUser({required this.uid, required this.email, required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user)
  => AuthUser(
    uid: user.uid,
    email: user.email, 
    isEmailVerified: user.emailVerified
  );

  factory AuthUser.fromFacebook(User user)
  => AuthUser(
    uid: user.uid,
    email: user.email, 
    isEmailVerified: true,
  );
}