import 'package:Hercules/data/dto/profile_dto.dart';
import 'package:Hercules/data/repositories/user/profile_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileFirebaseDataSource implements ProfileRemoteDataSource {

  String _tableName = 'users';
  String _columnId = 'id';

  @override
  Future<ProfileDto?> getProfile(String id) async {
    return await FirebaseFirestore.instance
        .collection(_tableName)
        .where(_columnId, isEqualTo: id)
        .get()
        .then((snapshot) {
          return snapshot.docs.isNotEmpty
              ? convertToDto(snapshot.docs.first)
              : null;
        });
  }

  @override
  Future<void> createProfile(ProfileDto dto) async {
    await FirebaseFirestore.instance
        .collection(_tableName)
        .add(dto.toJson());
  }

  ProfileDto convertToDto(QueryDocumentSnapshot document) {
    return ProfileDto.fromJson(document.data() as Map<String, dynamic>);
  }
}