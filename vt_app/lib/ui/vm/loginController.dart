// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/providers/auth_provider.dart';
import 'package:volume_tracker/ui/vm/loginState.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController(this.ref) : super(const LoginStateInitial());

  final Ref ref;

  void login(String email, String password) async {
    state = const LoginStateLoading();
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password);
    } catch (e) {
      state = LoginStateError(e.toString());
    }
  }

  void logout() async {
    await ref.read(authRepositoryProvider).signOut();
  }

  Future<User?> getUser() async {
    return ref.read(authRepositoryProvider).getUser();
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref);
});
