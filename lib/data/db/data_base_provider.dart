import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'user/current_profile_dao.dart';

/// [DataBaseProvider] provides instance of database and creates tables
class DataBaseProvider {

  /// Name of app database
  final _appDb = "indoor.db";
  /// Current version of app database
  final _appDbVersion = 1;
  /// Current database instance
  Database? _database;

  Database get dbInstance => _database != null
      ? _database!
      : throw Exception("Database isn't initialized");

  Future<void> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _appDb);
    _database = await openDatabase(path, version: _appDbVersion, onCreate: _createTables);
  }

  /// Create tables when the database is first created
  Future<void> _createTables(Database db, int version) async {
    await CurrentProfileDao.createTable(db);
  }

  Future<void> clearTables(Database db) async {
    await CurrentProfileDao.clearTable(db);
  }
}