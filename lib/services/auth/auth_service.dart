import 'auth_provider.dart';
import 'auth_user.dart';
import 'firebase_auth_provider.dart';
import 'facebook_auth_provider.dart';

class AuthService implements AuthProvider{
  final AuthProvider provider;
  const AuthService(this.provider);
  
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  factory AuthService.facebook() => AuthService(FacebookAuthProvider());

  @override
  Future<AuthUser> createUser({required String firstName, required String lastName, required String email, required String password}) 
  => provider.createUser(email: email, password: password, firstName: firstName, lastName: lastName);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({required String email, required String password}) 
  => provider.login(email: email, password: password);

  @override
  Future<void> logout() 
  => provider.logout();

  @override
  Future<void> sendEmailVerification() 
  => provider.sendEmailVerification();
  
  @override
  Future<void> initialize() 
  => provider.initialize();
  
  @override
  Future<void> sendPasswordResetEmail({required String email})
  => provider.sendPasswordResetEmail(email: email);
  
  @override
  Future<void> reloadUser() => provider.reloadUser();
  
  @override
  Future<AuthUser?> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }
}