import 'package:flutter/material.dart';
import 'services/revenuecat_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'pages/splash_page.dart';
import 'services/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RevenueCatService.init();
  runApp(const StudyHiveApp());
}

class StudyHiveApp extends StatelessWidget {
  const StudyHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        return MaterialApp(
          title: 'StudyHive',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppState().isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(AppState().languageCode),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
            Locale('fr'),
            Locale('tl'),
          ],
          home: const SplashPage(),
        );
      },
    );
  }
}
