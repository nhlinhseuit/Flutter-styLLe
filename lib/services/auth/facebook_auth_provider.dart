import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:stylle/services/auth/auth_exceptions.dart';
import 'package:stylle/services/auth/auth_provider.dart';
import 'package:stylle/services/auth/auth_user.dart';

class FacebookAuthProvider implements AuthProvider {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;

  @override
  Future<AuthUser> createUser({required String firstName, required String lastName, required String email, required String password}) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  AuthUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> login({String email = '', String password =''}) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
      // or FacebookAuth.i.login()
      if (result.status == LoginStatus.success) {
        // you are logged
        // final AccessToken accessToken = result.accessToken!;
        final userData = await FacebookAuth.instance.getUserData();
        print(userData['email']);
        return AuthUser(uid: userData['uid'], email: userData['email'], isEmailVerified: true);
      } else {
        print(result.status);
        print(result.message);
        return const AuthUser(uid: 'uid', email: 'email', isEmailVerified: false);
      }
    } catch (e) {
      print(e.toString());
      return const AuthUser(uid: 'uid', email: 'email', isEmailVerified: false);
    }
  }

  @override
  Future<void> logout() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
  }

  @override
  Future<void> reloadUser() {
    // TODO: implement reloadUser
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() async {
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
  }

}