abstract class ProfileFields {
  ProfileFields._();

  static String id = "id";
  static String name = "name";
  static String isTrainer = "is_trainer";
}

class ProfileDbEntity {

  final String id;
  final String name;
  final bool isTrainer;

  ProfileDbEntity({required this.id, required this.name, required this.isTrainer});

  factory ProfileDbEntity.fromDbFormat(Map<String, dynamic> map) => ProfileDbEntity(
      id: map[ProfileFields.id] as String,
      name: map[ProfileFields.name] as String,
      isTrainer: (map[ProfileFields.isTrainer] as int) == 1 ? true : false,
  );

  Map<String, dynamic> toDbFormat() => {
    ProfileFields.id: id,
    ProfileFields.name: name,
    ProfileFields.isTrainer: isTrainer ? 1 : 0,
  };
}