import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test888/core/theme/app_theme.dart';
import 'package:test888/core/providers/app_language_provider.dart';
import 'package:test888/core/providers/app_theme_provider.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/config/routes/app_routes.dart';
import 'package:test888/config/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = AppThemeProvider();
  final languageProvider = AppLanguageProvider();
  await Future.wait([
    themeProvider.load(),
    languageProvider.load(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size usually
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final themeProvider = context.watch<AppThemeProvider>();
        final languageProvider = context.watch<AppLanguageProvider>();

        return MaterialApp(
          title: "Let's Parky",
          theme: themeProvider.buildLightTheme(AppTheme.lightTheme(languageProvider.isArabic)),
          darkTheme: themeProvider.buildDarkTheme(AppTheme.darkTheme(languageProvider.isArabic)),
          themeMode: themeProvider.themeMode,
          locale: languageProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('ar'), // Arabic
          ],
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
