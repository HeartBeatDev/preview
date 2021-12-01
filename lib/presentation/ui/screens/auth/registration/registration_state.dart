import 'package:firebase_auth/firebase_auth.dart';

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final bool isMyProfileCreated;

  RegistrationSuccess(this.isMyProfileCreated);
}

class RegistrationFailure extends RegistrationState {
  final FirebaseAuthException exception;

  RegistrationFailure(this.exception);
}

class InvalidEmail extends RegistrationFailure {
  InvalidEmail(FirebaseAuthException exception) : super(exception);
}

class WeakPassword extends RegistrationFailure {
  WeakPassword(FirebaseAuthException exception) : super(exception);
}

class EmailAlreadyInUse extends RegistrationFailure {
  EmailAlreadyInUse(FirebaseAuthException exception) : super(exception);
}