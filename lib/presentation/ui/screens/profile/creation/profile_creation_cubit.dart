import 'package:Hercules/domain/usecases/create_profile_user_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../logger.dart';
import 'profile_creation_state.dart';

class ProfileCreationCubit extends Cubit<ProfileCreationState> {

  final CreateProfileUseCase _createProfileUseCase;

  ProfileCreationCubit(CreateProfileUseCase createProfileUseCase) :
        _createProfileUseCase = createProfileUseCase,
        super(ProfileCreationInitial());

  void createProfile(String name, bool isTrainer) async {
    emit(ProfileCreationLoading());
    try {
      await _createProfileUseCase.createProfile(name, isTrainer);
      emit(ProfileCreationSuccess());
    } catch (e) {
      emit(ProfileCreationFailure());
      Logger.error(e.toString());
    }
  }
}