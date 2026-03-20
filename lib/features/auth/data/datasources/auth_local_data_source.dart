import 'package:reel_clone/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String username, String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  UserModel? _currentUser;

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'dummy@test.com' && password == 'password123') {
      _currentUser = const UserModel(
        uid: 'user123',
        email: 'dummy@test.com',
        username: '@dummy_user',
      );
      return _currentUser!;
    } else {
      throw Exception(
        'Invalid email or password. Use dummy@test.com / password123',
      );
    }
  }

  @override
  Future<UserModel> signup(
    String username,
    String email,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.length < 6) {
      throw Exception('Invalid email or weak password');
    }

    _currentUser = UserModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      username: username,
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // In a real app we would check SharedPreferences or SecureStorage
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentUser;
  }
}
