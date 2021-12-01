import 'package:Hercules/domain/entities/profile.dart';
import 'package:Hercules/domain/repositories/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateProfileUseCase {

  final ProfileRepository _repository;

  CreateProfileUseCase(ProfileRepository repository) : _repository = repository;

  Future<void> createProfile(String name, bool isTrainer) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final profile = Profile(
        id: firebaseUser?.uid ?? "",
        name: name,
        isTrainer: isTrainer
    );
    return await _repository.createProfile(profile);
  }
}