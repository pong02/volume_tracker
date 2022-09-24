// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/providers/auth_provider.dart';
import 'package:volume_tracker/ui/homeScreen.dart';
import 'package:volume_tracker/ui/loginScreen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //lstener to listen for when LOGOUT NEEDS POPPING
    ref.listen<AsyncValue<User?>>(
      AuthService.authChangesProvider,
      (previous, next) {
        next.whenOrNull(
          data: (User? user) {
            if (user == null) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
        );
      },
    );

    //initial state (cold launch -> persistent login)
    final _authState = ref.watch(authStateProvider);

    //what pages to show on each state?
    return _authState.when(
        data: (user) {
          if (user != null) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
        loading: () => const SplashScreen(),
        error: (e, trace) => const LoginScreen());
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}

class AuthService {
  static final authChangesProvider = StreamProvider((ref) {
    return FirebaseAuth.instance.authStateChanges();
  });
}
