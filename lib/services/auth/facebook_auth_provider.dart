import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
  Future<AuthUser> login({required String email, required String password}) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        _accessToken = result.accessToken;
        final userData = await FacebookAuth.instance.getUserData();
        _userData = userData;
      } else {
        print(result.status);
        print(result.message);
      }
    } catch (_) {}
      throw UnimplementedError();
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