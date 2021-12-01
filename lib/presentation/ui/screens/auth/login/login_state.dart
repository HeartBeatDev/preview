import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final bool isMyProfileCreated;

  LoginSuccess(this.isMyProfileCreated);
}

class LoginFailure extends LoginState {
  final FirebaseAuthException exception;

  LoginFailure(this.exception);
}

class InvalidEmail extends LoginFailure {
  InvalidEmail(FirebaseAuthException exception) : super(exception);
}

class UnknownUser extends LoginFailure {
  UnknownUser(FirebaseAuthException exception) : super(exception);
}

class WrongPassword extends LoginFailure {
  WrongPassword(FirebaseAuthException exception) : super(exception);
}
