import 'package:firebase_auth/firebase_auth.dart';
import 'package:reel_clone/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String username, String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return UserModel(
        uid: credential.user!.uid,
        email: credential.user!.email ?? '',
        username: credential.user!.displayName ?? 'User', // Fallback
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw Exception('ID or password not matched');
      }
      throw Exception(e.message ?? 'Login failed');
    } catch (e) {
      throw Exception('ID or password not matched');
    }
  }

  @override
  Future<UserModel> signup(
    String username,
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name with the username provided
      await credential.user!.updateDisplayName(username);

      return UserModel(
        uid: credential.user!.uid,
        email: credential.user!.email ?? '',
        username: username,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Signup failed');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      return UserModel(
        uid: currentUser.uid,
        email: currentUser.email ?? '',
        username: currentUser.displayName ?? 'User',
      );
    }
    return null;
  }
}
