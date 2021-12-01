import 'package:Hercules/core/error_code.dart';
import 'package:Hercules/domain/usecases/login_use_case.dart';
import 'package:Hercules/domain/usecases/profile_use_case.dart';
import 'package:Hercules/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {

  final LoginUseCase _loginUseCase;
  final ProfileUseCase _profileUseCase;

  LoginCubit(LoginUseCase loginUseCase, ProfileUseCase profileUseCase):
        _loginUseCase = loginUseCase,
        _profileUseCase = profileUseCase,
        super(LoginInitial());

  void signIn(String email, String password) async {
    emit(LoginLoading());
    try {
      final bool isSuccess = await _loginUseCase.signIn(email, password);
      if (isSuccess) {
        final isMyProfileCreated = await _profileUseCase.isMyProfileCreated();
        emit(LoginSuccess(isMyProfileCreated));
      }
    } on FirebaseAuthException catch (e) {
      Logger.error(e.message ?? "");

      switch(e.code) {
        case FirebaseErrorCode.invalidEmail:
          emit(InvalidEmail(e));
          break;
        case FirebaseErrorCode.unknownUser:
          emit(UnknownUser(e));
          break;
        case FirebaseErrorCode.wrongPassword:
          emit(WrongPassword(e));
          break;
        default:
          emit(LoginFailure(e));
          break;
      }
    }
  }

  void resetPassword(String email) async {
    try {
      await _loginUseCase.resetPassword(email);
    } catch (e) {
      Logger.error(e.toString());
    }
  }
}
