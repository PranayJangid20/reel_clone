import 'package:reel_clone/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:reel_clone/features/auth/domain/entities/user_entity.dart';
import 'package:reel_clone/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      return await remoteDataSource.login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> signup(
    String username,
    String email,
    String password,
  ) async {
    try {
      return await remoteDataSource.signup(username, email, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }
}
