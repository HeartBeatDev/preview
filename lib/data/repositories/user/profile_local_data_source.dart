import 'package:Hercules/data/db/user/profile_db_entity.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileDbEntity?> getMyProfile();
  Future<void> saveMyProfile(ProfileDbEntity user);
}