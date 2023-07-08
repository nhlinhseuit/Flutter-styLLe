import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylle/services/auth/google_auth_service.dart';

import 'auth_provider.dart';
import 'auth_user.dart';
import 'firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  factory AuthService.google() => AuthService(AuthProviderGoogle());

  @override
  Future<AuthUser> createUser(
          {required String firstName,
          required String lastName,
          required String email,
          required String password}) =>
      provider.createUser(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      provider.sendPasswordResetEmail(email: email);

  @override
  Future<void> reloadUser() => provider.reloadUser();

  @override
  Future<void> changePassword(
          {required String currentPassword, required String newPassword}) =>
      provider.changePassword(
          currentPassword: currentPassword, newPassword: newPassword);

  static Future<List<String>> fetchSignInMethodsForEmail(String email) async {
    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return signInMethods;
    } catch (e) {
      print('Error fetching sign-in methods: $e');
      return [];
    }
  }
}
