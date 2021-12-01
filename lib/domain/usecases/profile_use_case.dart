import 'package:Hercules/domain/entities/profile.dart';
import 'package:Hercules/domain/repositories/profile_repository.dart';

class ProfileUseCase {

  final ProfileRepository _repository;

  ProfileUseCase(ProfileRepository repository) : _repository = repository;

  Future<bool> isLoggedIn() async {
    return await _repository.isLoggedIn();
  }

  Future<bool> isMyProfileCreated() async {
    return await _repository.isMyProfileCreated();
  }

  Future<Profile?> getProfile(String id) async {
    return await _repository.getProfile(id);
  }

  Future<Profile?> getMyProfile() async {
    return await _repository.getMyProfile();
  }
}