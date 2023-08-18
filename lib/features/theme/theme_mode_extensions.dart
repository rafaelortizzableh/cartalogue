import 'package:flutter/material.dart';

import 'theme.dart';

extension ThemeModeExtension on String? {
  ThemeMode toThemeMode() {
    switch (this) {
      case ThemeModeConstants.lightThemeMode:
        return ThemeMode.light;
      case ThemeModeConstants.darkThemeMode:
        return ThemeMode.dark;
      case ThemeModeConstants.systemThemeMode:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}

extension DisplayStringExtension on ThemeMode {
  String toDisplayString() {
    switch (this) {
      case ThemeMode.light:
        return ThemeModeConstants.lightThemeModeDisplayString;
      case ThemeMode.dark:
        return ThemeModeConstants.darkThemeModeDisplayString;
      case ThemeMode.system:
        return ThemeModeConstants.systemThemeModeDisplayString;
    }
  }
}
