import 'package:Hercules/domain/usecases/profile_use_case.dart';
import 'package:Hercules/presentation/ui/screens/splash/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logger.dart';

class SplashCubit extends Cubit<SplashState> {
  final ProfileUseCase _profileUseCase;

  SplashCubit(ProfileUseCase profileUseCase) :
        _profileUseCase = profileUseCase,
        super(SplashInitial()) {
    _checkCurrentUser();
  }

  void _checkCurrentUser() async {
    try {
      final bool isLoggedIn = await _profileUseCase.isLoggedIn();
      if (isLoggedIn) {
        final isMyProfileCreated = await _profileUseCase.isMyProfileCreated();
        if (isMyProfileCreated) {
          emit(NavigateToHome());
        } else {
          emit(NavigateToProfileCreation());
        }
      } else {
        emit(NavigateToLogin());
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(NavigateToLogin());
    }
  }
}
