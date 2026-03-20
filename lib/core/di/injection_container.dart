import 'package:get_it/get_it.dart';
import 'package:reel_clone/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:reel_clone/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:reel_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:reel_clone/features/auth/domain/usecases/auth_usecases.dart';
import 'package:reel_clone/features/auth/presentation/cubit/auth_cubit.dart';

import 'package:reel_clone/features/reels/data/datasources/video_remote_data_source.dart';
import 'package:reel_clone/features/reels/data/repositories/video_repository_impl.dart';
import 'package:reel_clone/features/reels/domain/repositories/video_repository.dart';
import 'package:reel_clone/features/reels/domain/usecases/get_videos.dart';
import 'package:reel_clone/features/reels/presentation/cubit/reel_cubit.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // === Features - Auth ===
  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      signupUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // === Features - Reels ===
  // Cubit
  sl.registerFactory(() => ReelCubit(getVideosUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetVideos(sl()));

  // Repository
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<VideoRemoteDataSource>(
    () => VideoRemoteDataSourceImpl(),
  );
}
