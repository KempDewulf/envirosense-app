import 'package:flutter/material.dart';

abstract class AppStateInterface {
  void updateLocale(Locale locale);
  Locale? get currentLocale;
}
