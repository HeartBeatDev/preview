import 'package:Hercules/core/error_code.dart';
import 'package:Hercules/domain/usecases/profile_use_case.dart';
import 'package:Hercules/domain/usecases/registration_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../logger.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {

  final RegistrationUseCase _registrationUseCase;
  final ProfileUseCase _profileUseCase;

  RegistrationCubit(
      RegistrationUseCase registrationUseCase,
      ProfileUseCase profileUseCase
      ) :_registrationUseCase = registrationUseCase,
        _profileUseCase = profileUseCase,
        super(RegistrationInitial());

  void signUp(String email, String password) async {
    emit(RegistrationLoading());
    try {
      final bool isSuccess = await _registrationUseCase.signUp(email, password);
      if (isSuccess) {
        final isMyProfileCreated = await _profileUseCase.isMyProfileCreated();
        emit(RegistrationSuccess(isMyProfileCreated));
      }
    } on FirebaseAuthException catch (e) {
      Logger.error(e.message ?? "");

      switch(e.code) {
        case FirebaseErrorCode.invalidEmail:
          emit(InvalidEmail(e));
          break;
        case FirebaseErrorCode.weakPassword:
          emit(WeakPassword(e));
          break;
        case FirebaseErrorCode.emailAlreadyInUse:
          emit(EmailAlreadyInUse(e));
          break;
        default:
          emit(RegistrationFailure(e));
          break;
      }
    }
  }
}
