import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show
        AuthCredential,
        EmailAuthProvider,
        FirebaseAuth,
        FirebaseAuthException,
        User;
import 'package:stylle/services/collections/logging.dart';
import 'package:stylle/services/notifiers/current_user.dart';

import '../../firebase_options.dart';
import '../collections/my_users.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

class FirebaseAuthProvider implements MyAuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        final MyUser newUser = MyUser(
            uid: user.uid!,
            firstName: firstName,
            lastName: lastName,
            email: email);
        await newUser.createUser();
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> login(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = currentUser;
    if (user != null) {
      final userLogger = CurrentUser().user;
      Logging logger = Logging(
          uid: userLogger.uid,
          email: userLogger.email,
          firstName: userLogger.firstName,
          lastName: userLogger.lastName,
          time: DateTime.now(),
          type: LoggingType.logout);
      await logger.addLogging();
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> reloadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
  }

  @override
  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential credentials = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword.trim(),
      );
      await user.reauthenticateWithCredential(credentials);
      await user.updatePassword(newPassword.trim());
      
      final userLogger = CurrentUser().user;
      Logging logger = Logging(
          uid: userLogger.uid,
          email: userLogger.email,
          firstName: userLogger.firstName,
          lastName: userLogger.lastName,
          time: DateTime.now(),
          type: LoggingType.changePassword);
      await logger.addLogging();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
