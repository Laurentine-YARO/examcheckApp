import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedStrings = {
    'en': {
      'welcome': 'Welcome',
      'login': 'Login',
      'logout': 'Log Out',
      'create_account': 'Create Account',
      'search_results': 'Search Results',
      'view_history': 'View History',
      'language': 'Language',
      'notifications': 'Notifications',
    },
    'fr': {
      'welcome': 'Bienvenue',
      'login': 'Connexion',
      'logout': 'Déconnexion',
      'create_account': 'Créer un compte',
      'search_results': 'Résultats de recherche',
      'view_history': 'Historique',
      'language': 'Langue',
      'notifications': 'Notifications',
    },
  };

  String translate(String key) {
    return _localizedStrings[locale.languageCode]?[key] ??
        '[$key]'; // fallback
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
