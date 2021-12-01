import 'package:sqflite/sqflite.dart';
import 'profile_db_entity.dart';

class CurrentProfileDao {

  static const _tableName = "current_profile_table";

  final Database _database;

  CurrentProfileDao(Database database) : _database = database;

  static Future<void> createTable(Database database) async {
    await database.execute('''
    CREATE TABLE $_tableName (
    ${ProfileFields.id} TEXT PRIMARY KEY,
    ${ProfileFields.name} TEXT,
    ${ProfileFields.isTrainer} INTEGER
    )''');
  }

  static Future<void> clearTable(Database database) async {
    await database.execute('''
      DELETE FROM $_tableName
    ''');
  }

  Future<void> insertCurrentProfile(ProfileDbEntity userDbEntity) async {
    await _database.transaction((txn) async {
      await txn.delete(_tableName);
      await txn.insert(
          _tableName,
          userDbEntity.toDbFormat(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    });
  }

  Future<ProfileDbEntity?> queryCurrentProfile() async {
    final userRow = await _database.query(_tableName);
    return userRow.isEmpty ? null : ProfileDbEntity.fromDbFormat(userRow.first);
  }
}
