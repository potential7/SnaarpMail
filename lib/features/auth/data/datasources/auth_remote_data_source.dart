import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('User is null');
      }
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'User',
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      print('FirebaseAuthException in login: ${e.code} - ${e.message}');
      print('Stack trace: $stackTrace');

      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Wrong password provided for that user.');
        case 'invalid-credential':
          throw Exception('Invalid credentials provided.');
        case 'invalid-email':
          throw Exception('The email address is invalid.');
        case 'user-disabled':
          throw Exception('This user account has been disabled.');
        case 'network-request-failed':
        case 'internal-error':
          throw Exception(
            'Network or internal error. Please check your connection.',
          );
        default:
          throw Exception(e.message ?? 'Authentication failed');
      }
    } catch (e, stackTrace) {
      print('Unknown exception in login: $e');
      print('Stack trace: $stackTrace');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('User is null');
      }
      // optionally update the displayName natively on Firebase
      await user.updateDisplayName(name);

      return UserModel(id: user.uid, email: user.email ?? '', name: name);
    } on FirebaseAuthException catch (e, stackTrace) {
      print('FirebaseAuthException in signup: ${e.code} - ${e.message}');
      print('Stack trace: $stackTrace');

      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('An account already exists for that email.');
        case 'weak-password':
          throw Exception('The password provided is too weak.');
        case 'invalid-email':
          throw Exception('The email address is invalid.');
        case 'network-request-failed':
        case 'internal-error':
          throw Exception(
            'Network or internal error. Please check your connection.',
          );
        default:
          throw Exception(e.message ?? 'Signup failed');
      }
    } catch (e, stackTrace) {
      print('Unknown exception in signup: $e');
      print('Stack trace: $stackTrace');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
