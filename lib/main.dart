import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const StudyHiveApp());
}

class StudyHiveApp extends StatelessWidget {
  const StudyHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyHive',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
    );
  }
}
