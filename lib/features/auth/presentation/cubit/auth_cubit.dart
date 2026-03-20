import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_clone/features/auth/domain/usecases/auth_usecases.dart';
import 'package:reel_clone/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuth() async {
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(email, password);
      emit(Authenticated(user));
    } catch (e) {
      debugPrint(e.toString());
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      emit(Unauthenticated()); // Reset back so user can try again
    }
  }

  Future<void> signup(String username, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await signupUseCase(username, email, password);
      emit(Authenticated(user));
    } catch (e) {
      debugPrint(e.toString());
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      emit(Unauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated()); // force unauthenticated anyways
    }
  }
}
