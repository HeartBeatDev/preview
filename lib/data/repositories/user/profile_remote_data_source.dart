import 'package:Hercules/data/dto/profile_dto.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileDto?> getProfile(String id);
  Future<void> createProfile(ProfileDto dto);
}