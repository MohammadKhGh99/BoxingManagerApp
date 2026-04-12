import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:boxing_coach_manager/app_localizations.dart';
import 'package:boxing_coach_manager/home_page.dart';
import 'package:boxing_coach_manager/providers/app_data_provider.dart';
import 'package:boxing_coach_manager/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocaleProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppDataProvider()..initialize(),
        ),
      ],
      child: const BoxingCoachApp(),
    ),
  );
}

class BoxingCoachApp extends StatelessWidget {
  const BoxingCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Boxing Coach Manager',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Segoe UI',
      ),
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('ar', 'SA'), // Arabic
        Locale('he', 'IL'), // Hebrew
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomePage(),
    );
  }
}
