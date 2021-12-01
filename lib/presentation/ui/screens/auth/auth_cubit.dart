import 'package:Hercules/domain/usecases/profile_use_case.dart';
import 'package:Hercules/domain/usecases/social_auth_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logger.dart';
import 'auth_state.dart';
import 'social_auth_type.dart';

class AuthCubit extends Cubit<AuthState> {

  final SocialAuthUseCase _socialAuthUseCase;
  final ProfileUseCase _profileUseCase;

  AuthCubit(SocialAuthUseCase socialAuthUseCase, ProfileUseCase profileUseCase)
      : _socialAuthUseCase = socialAuthUseCase,
        _profileUseCase = profileUseCase,
        super(AuthInitial());

  void signInBySocialAuth(SocialAuthType type) async {
    try {
      bool isSuccess = false;
      switch (type) {
        case SocialAuthType.google:
          isSuccess = await _socialAuthUseCase.signInWithGoogle();
          break;
        case SocialAuthType.facebook:
          isSuccess = await _socialAuthUseCase.signInWithFacebook();
          break;
        case SocialAuthType.ios:
          isSuccess = await _socialAuthUseCase.signInWithApple();
          break;
      }
      if (isSuccess) {
        final isMyProfileCreated = await _profileUseCase.isMyProfileCreated();
        emit(SocialAuthSuccess(isMyProfileCreated));
      }
    } on FirebaseAuthException catch (e) {
      Logger.error(e.message ?? "");
      emit(SocialAuthFailure(e));
    }
  }
}
