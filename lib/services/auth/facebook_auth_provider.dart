import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:stylle/services/auth/auth_exceptions.dart';
import 'package:stylle/services/auth/auth_provider.dart';
import 'package:stylle/services/auth/auth_user.dart';

import '../../firebase_options.dart';

class FacebookAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({required String firstName, required String lastName, required String email, required String password}) async {
      return const AuthUser(uid: 'uid', email: 'email', isEmailVerified: false);
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFacebook(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp (
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> login({String email = '', String password =''}) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(); 
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        return AuthUser(uid: userData['uid'], email: userData['email'], isEmailVerified: true);
      } else if (result.status == LoginStatus.cancelled) {
        throw UserNotLoggedInAuthException();
      } else if (result.status == LoginStatus.failed) {
        throw GenericAuthException();
      }
      return const AuthUser(uid: 'uid', email: 'email', isEmailVerified: false);
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    await FacebookAuth.instance.logOut();
  }

  @override
  Future<void> reloadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
  }

  @override
  Future<void> sendEmailVerification() async {
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
  }

}