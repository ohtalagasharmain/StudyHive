import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final Map<String, String> _languages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'tl': 'Filipino',
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final appState = AppState();
        return HoneycombBackground(
          showGradient: false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.honeyDark),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(L10n.of(context, 'settings'), 
                style: const TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold)),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(L10n.of(context, 'appearance')),
                  Card(
                    child: SwitchListTile(
                      title: Text(L10n.of(context, 'darkMode')),
                      subtitle: const Text('Toggle app theme'),
                      value: appState.isDarkMode,
                      onChanged: (val) => appState.toggleTheme(),
                      activeThumbColor: AppColors.honeyDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle(L10n.of(context, 'language')),
                  Card(
                    child: ListTile(
                      title: const Text('Select Language'),
                      subtitle: Text(_languages[appState.languageCode] ?? 'English'),
                      trailing: const Icon(Icons.language),
                      onTap: () => _showLanguageDialog(context, appState),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('About'),
                  const Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Version'),
                          trailing: Text('1.0.0'),
                        ),
                        Divider(height: 1),
                        ListTile(
                          title: Text('Terms of Service'),
                          trailing: Icon(Icons.open_in_new, size: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context, 'language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.entries.map((entry) => RadioListTile<String>(
            title: Text(entry.value),
            value: entry.key,
            groupValue: appState.languageCode,
            onChanged: (val) {
              if (val != null) appState.setLanguage(val);
              Navigator.pop(context);
            },
            activeColor: AppColors.honeyDark,
          )).toList(),
        ),
      ),
    );
  }
}
