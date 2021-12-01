abstract class AuthRepository {
  Future<bool> signIn(String email, String password);
  Future<bool> signUp(String email, String password);
  Future<bool> signInWithGoogle();
  Future<bool> signInWithFacebook();
  Future<bool> signInWithApple();
  Future<void> resetPassword(String email);
}