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
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref);
});
