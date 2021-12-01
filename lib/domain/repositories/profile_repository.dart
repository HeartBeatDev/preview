import 'package:Hercules/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<bool> isLoggedIn();
  Future<bool> isMyProfileCreated();
  Future<Profile?> getProfile(String id);
  Future<Profile?> getMyProfile();
  Future<void> createProfile(Profile profile);
}