import 'package:flutter/material.dart';
import 'app_state.dart';

class L10n {
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'StudyHive',
      'welcomeBack': 'Welcome Back!',
      'settings': 'App Preferences',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'studyGroups': 'Study Groups',
      'savedResources': 'Saved Resources',
      'signOut': 'Sign Out',
      'appearance': 'Appearance',
      'myStudyGroups': 'My Study Groups',
    },
    'es': {
      'appTitle': 'StudyHive',
      'welcomeBack': '¡Bienvenido de nuevo!',
      'settings': 'Preferencias',
      'darkMode': 'Modo oscuro',
      'language': 'Idioma',
      'studyGroups': 'Grupos de estudio',
      'savedResources': 'Recursos guardados',
      'signOut': 'Cerrar sesión',
      'appearance': 'Apariencia',
      'myStudyGroups': 'Mis grupos de estudio',
    },
    // Add more here (fr, tl, etc.)
  };

  static String of(BuildContext context, String key) {
    String code = AppState().languageCode;
    return _localizedValues[code]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}
