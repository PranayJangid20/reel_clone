import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_clone/core/di/injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:reel_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:reel_clone/features/auth/presentation/cubit/auth_state.dart';
import 'package:reel_clone/features/auth/presentation/pages/login_screen.dart';
import 'package:reel_clone/features/reels/presentation/cubit/reel_cubit.dart';
import 'package:reel_clone/features/reels/presentation/pages/reels_screen.dart';
import 'package:reel_clone/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Requires flutterfire configure)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize dependency injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => di.sl<AuthCubit>()..checkAuth()),
        BlocProvider<ReelCubit>(create: (_) => di.sl<ReelCubit>()),
      ],
      child: MaterialApp(
        title: 'Reels Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

/// A wrapper that decides which screen to show based on Authentication state.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Optional logic based on auth changes
      },
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is Authenticated) {
          return const ReelsScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
