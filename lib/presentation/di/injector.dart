import 'package:Hercules/data/db/data_base_provider.dart';
import 'package:Hercules/data/db/user/current_profile_dao.dart';
import 'package:Hercules/data/mappers/profile_mapper.dart';
import 'package:Hercules/data/repositories/auth/auth_remote_data_source.dart';
import 'package:Hercules/data/repositories/auth/auth_repository_impl.dart';
import 'package:Hercules/data/repositories/user/profile_local_data_source.dart';
import 'package:Hercules/data/repositories/user/profile_remote_data_source.dart';
import 'package:Hercules/data/repositories/user/profile_repository_impl.dart';
import 'package:Hercules/data/sources/auth/auth_firebase_data_source.dart';
import 'package:Hercules/data/sources/user/profile_db_data_source.dart';
import 'package:Hercules/data/sources/user/profile_firebase_data_source.dart';
import 'package:Hercules/domain/repositories/auth_repository.dart';
import 'package:Hercules/domain/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class Injector extends StatelessWidget {
  final DataBaseProvider dbProvider;
  final Widget child;

  Injector({required this.dbProvider, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Database>(create: (_) => dbProvider.dbInstance),
        ...getDao(),
        ...getAuthProviders(),
        ...getUserProviders()
      ],
      child: child,
    );
  }

  List<RepositoryProvider> getDao() {
    return [
      RepositoryProvider<CurrentProfileDao>(
          create: (context) => CurrentProfileDao(context.read())
      ),
    ];
  }

  List<RepositoryProvider> getAuthProviders() {
    return [
      RepositoryProvider<AuthRemoteDataSource>(
          create: (context) => AuthFirebaseDataSource()
      ),
      RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(context.read())
      ),
    ];
  }

  List<RepositoryProvider> getUserProviders() {
    return [
      RepositoryProvider<ProfileLocalDataSource>(
          create: (context) => ProfileDbDataSource(context.read())
      ),
      RepositoryProvider<ProfileRemoteDataSource>(
          create: (context) => ProfileFirebaseDataSource()
      ),
      RepositoryProvider<ProfileMapper>(
          create: (context) => ProfileMapper()
      ),
      RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepositoryImpl(context.read(), context.read(), context.read())
      ),
    ];
  }
}