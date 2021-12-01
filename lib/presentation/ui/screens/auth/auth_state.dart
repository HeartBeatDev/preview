import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class SocialAuthSuccess extends AuthState {
  final bool isMyProfileCreated;

  SocialAuthSuccess(this.isMyProfileCreated);
}

class SocialAuthFailure extends AuthState {
  final FirebaseAuthException exception;

  SocialAuthFailure(this.exception);
}
