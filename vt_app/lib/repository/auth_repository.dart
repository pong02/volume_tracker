import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  const AuthRepository(this._auth);

  final FirebaseAuth _auth;

  //provides Stream of user state (time out, login/out) LISTEN TO THIS
  Stream<User?> get authStateChange => _auth.idTokenChanges();

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
      //if user returned is null, sign in unsuccessful
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException("User not found");
      } else if (e.code == 'wrong-password') {
        throw AuthException("Invalid Password!");
      } else {
        throw AuthException('Unknown Error. Please try again later');
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthException implements Exception {
  final String msg;

  AuthException(this.msg);

  @override
  String toString() {
    return msg;
  }
}
