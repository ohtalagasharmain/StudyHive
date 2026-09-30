// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'StudyHive';

  @override
  String get welcomeBack => '¡Bienvenido de nuevo!';

  @override
  String get settings => 'Preferencias de la aplicación';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get studyGroups => 'Grupos de estudio';

  @override
  String get savedResources => 'Recursos guardados';

  @override
  String get signOut => 'Cerrar sesión';
}
