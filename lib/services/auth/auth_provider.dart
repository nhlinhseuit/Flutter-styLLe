import 'auth_user.dart';

abstract class MyAuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> changePassword({required String currentPassword, required String newPassword});
  Future<void> reloadUser();
}