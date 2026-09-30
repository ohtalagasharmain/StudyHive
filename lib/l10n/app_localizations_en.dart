// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'StudyHive';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get settings => 'App Preferences';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get studyGroups => 'Study Groups';

  @override
  String get savedResources => 'Saved Resources';

  @override
  String get signOut => 'Sign Out';
}
