import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<User?> signInWithGoogle();
  Future<User?> signInWithFacebook();
  Future<User?> signInWithApple();
  Future<void> resetPassword(String email);
}