import 'dart:convert';
import 'dart:math';

import 'package:Hercules/data/repositories/auth/auth_remote_data_source.dart';
import 'package:Hercules/logger.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthFirebaseDataSource implements AuthRemoteDataSource {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> signIn(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    );

    _logUserCredential(userCredential, "Email");

    return userCredential.user;
  }

  @override
  Future<User?> signUp(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );

    Logger.message("[Success registration by email]"
        "\nUser email: ${userCredential.user?.email}"
        "\nUser name: ${userCredential.user?.displayName}");

    return userCredential.user;
  }

  @override
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(authCredential);

      _logUserCredential(userCredential, "Google");

      return userCredential.user;
    }

    Logger.warning("[Process of authorization was canceled]");

    return null;
  }

  @override
  Future<User?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    final AccessToken? accessToken = result.accessToken;

    if (accessToken != null) {
      final facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);
      final userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);

      _logUserCredential(userCredential, "Facebook");

      return userCredential.user;
    }

    if (result.status == LoginStatus.cancelled)
      Logger.warning("[Process of authorization by Facebook was canceled]");

    return null;
  }

  @override
  Future<User?> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

    _logUserCredential(userCredential, "Apple");

    return userCredential.user;
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _logUserCredential(UserCredential userCredential, String authType) {
    Logger.message("[Success authorization by $authType]"
        "\nUser email: ${userCredential.user?.email}"
        "\nUser name: ${userCredential.user?.displayName}");
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}