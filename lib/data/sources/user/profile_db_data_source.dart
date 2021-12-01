import 'package:Hercules/data/db/user/current_profile_dao.dart';
import 'package:Hercules/data/db/user/profile_db_entity.dart';
import 'package:Hercules/data/repositories/user/profile_local_data_source.dart';

class ProfileDbDataSource implements ProfileLocalDataSource {

  final CurrentProfileDao _currentProfileDao;

  ProfileDbDataSource(CurrentProfileDao currentUserDao)
      : _currentProfileDao = currentUserDao;

  @override
  Future<ProfileDbEntity?> getMyProfile() async {
    return await _currentProfileDao.queryCurrentProfile();
  }

  @override
  Future<void> saveMyProfile(ProfileDbEntity user) async {
    await _currentProfileDao.insertCurrentProfile(user);
  }
}