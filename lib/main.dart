import 'package:Hercules/presentation/di/injector.dart';
import 'package:Hercules/presentation/ui/resources/locale_keys.g.dart';
import 'package:Hercules/presentation/ui/screens/splash/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/db/data_base_provider.dart';
import 'presentation/ui/resources/fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialization of Firebase
  await Firebase.initializeApp();
  /// Initialization of localization
  await EasyLocalization.ensureInitialized();
  /// Initialization of database instance
  final dbProvider = DataBaseProvider();
  await dbProvider.initDB();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: Injector(
          dbProvider: dbProvider,
          child: MyApp()
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LocaleKeys.appName.tr(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: Fonts.comfortaa,
      ),
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: SplashScreen(),
    );
  }
}
