import 'dart:io';

import 'package:envirosense/presentation/widgets/models/language_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  LanguageService._();
  static final instance = LanguageService._();

  static const String _languageKey = 'language_code';
  late Locale _locale;
  late SharedPreferences _prefs;

  static const List<Language> supportedLanguages = [
    Language('en', 'English'),
    Language('nl', 'Nederlands'),
    Language('fr', 'Français'),
  ];

  static List<Locale> get supportedLocales => supportedLanguages.map((lang) => Locale(lang.code)).toList();

  Locale get locale => _locale;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final String? languageCode = _prefs.getString(_languageKey);
    if (languageCode != null) {
      _locale = Locale(languageCode);
      return;
    }

    final systemLocale = Platform.localeName.split('_')[0];
    final isSupported = supportedLanguages.any((lang) => lang.code == systemLocale);
    _locale = Locale(isSupported ? systemLocale : 'en');
  }

  Future<void> changeLocale({required Locale locale, bool systemDefault = false}) async {
    if (systemDefault) {
      await _prefs.remove(_languageKey);
      _locale = Locale(Platform.localeName.split('_')[0]);
    } else {
      _locale = locale;
      await _prefs.setString(_languageKey, locale.languageCode);
    }
    notifyListeners();
  }

  Locale? localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    if (_prefs.getString(_languageKey) != null) return null;
    if (locale != null) {
      if (supportedLocales.contains(locale)) {
        return _locale = locale;
      }
      return _locale = Locale(locale.languageCode);
    }
    return _locale;
  }
}
