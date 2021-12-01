import 'package:Hercules/data/dto/profile_dto.dart';
import 'package:Hercules/data/mappers/profile_mapper.dart';
import 'package:Hercules/data/repositories/user/profile_local_data_source.dart';
import 'package:Hercules/domain/entities/profile.dart';
import 'package:Hercules/domain/repositories/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {

  ProfileRemoteDataSource _remoteSource;
  ProfileLocalDataSource _localSource;
  ProfileMapper _profileMapper;

  ProfileRepositoryImpl(
      ProfileRemoteDataSource remoteSource,
      ProfileLocalDataSource localSource,
      ProfileMapper profileMapper
      ) : _remoteSource = remoteSource,
        _localSource = localSource,
        _profileMapper = profileMapper;

  @override
  Future<bool> isLoggedIn() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    return firebaseUser != null;
  }

  @override
  Future<bool> isMyProfileCreated() async {
    final localProfile = await _localSource.getMyProfile();
    if (localProfile != null)
      return true;
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final remoteProfile = await _remoteSource.getProfile(firebaseUser?.uid ?? "");
    if (remoteProfile != null) _saveMyProfile(remoteProfile);
    return remoteProfile != null;
  }

  @override
  Future<Profile?> getProfile(String id) async {
    final profile = await _remoteSource.getProfile(id);
    return _profileMapper.mapDtoToDomain(profile);
  }

  @override
  Future<Profile?> getMyProfile() async {
    final localProfile = await _localSource.getMyProfile();
    if (localProfile == null) {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final remoteProfile = await _remoteSource.getProfile(firebaseUser.uid);
        if (remoteProfile != null) _saveMyProfile(remoteProfile);
        return _profileMapper.mapDtoToDomain(remoteProfile);
      }
    } else {
      return _profileMapper.mapEntityToDomain(localProfile);
    }
  }

  @override
  Future<void> createProfile(Profile profile) async {
    final profileDto = _profileMapper.mapDomainToDto(profile);
    await _remoteSource.createProfile(profileDto);
    await _saveMyProfile(profileDto);
  }

  Future<void> _saveMyProfile(ProfileDto profile) async {
    final profileEntity = _profileMapper.mapDtoToEntity(profile);
    await _localSource.saveMyProfile(profileEntity);
  }
}