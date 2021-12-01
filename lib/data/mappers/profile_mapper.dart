import 'package:Hercules/data/db/user/profile_db_entity.dart';
import 'package:Hercules/data/dto/profile_dto.dart';
import 'package:Hercules/domain/entities/profile.dart';

class ProfileMapper {

  Profile? mapDtoToDomain(ProfileDto? dto) {
    return dto == null ? null : Profile(
      id: dto.id,
      name: dto.name,
      isTrainer: dto.isTrainer
    );
  }

  Profile? mapEntityToDomain(ProfileDbEntity? entity) {
    return entity == null ? null : Profile(
        id: entity.id,
        name: entity.name,
        isTrainer: entity.isTrainer
    );
  }

  ProfileDbEntity mapDtoToEntity(ProfileDto dto) {
    return ProfileDbEntity(
        id: dto.id,
        name: dto.name,
        isTrainer: dto.isTrainer
    );
  }

  ProfileDto mapDomainToDto(Profile domain) {
    return ProfileDto(
        id: domain.id,
        name: domain.name,
        isTrainer: domain.isTrainer,
    );
  }
}