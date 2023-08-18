import 'package:cartalogue/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeModeExtension', () {
    test(
        'Given a dark mode string, '
        'when converting that string to a ThemeMode, '
        'then the correct ThemeMode should be returned', () {
      const darkModeString = ThemeModeConstants.darkThemeMode;
      const expectedThemeMode = ThemeMode.dark;

      final actualThemeMode = darkModeString.toThemeMode();

      expect(actualThemeMode, expectedThemeMode);
    });

    test(
        'Given a light mode string,'
        'when converting that string to a ThemeMode, '
        'then the correct ThemeMode should be returned.', () {
      const lightModeString = ThemeModeConstants.lightThemeMode;
      const expectedThemeMode = ThemeMode.light;

      final actualThemeMode = lightModeString.toThemeMode();

      expect(actualThemeMode, expectedThemeMode);
    });

    test(
        'Given a system mode string, '
        'when converting that string to a ThemeMode, '
        'then the correct ThemeMode should be returned', () {
      const systemModeString = ThemeModeConstants.systemThemeMode;
      const expectedThemeMode = ThemeMode.system;

      final actualThemeMode = systemModeString.toThemeMode();

      expect(actualThemeMode, expectedThemeMode);
    });
  });

  group('DisplayStringExtension', () {
    test(
        'Given a dark mode ThemeMode, '
        'when converting that ThemeMode to a display string, '
        'then the correct display string should be returned.', () {
      const darkMode = ThemeMode.dark;
      const expectedDisplayString =
          ThemeModeConstants.darkThemeModeDisplayString;

      final actualDisplayString = darkMode.toDisplayString();

      expect(actualDisplayString, expectedDisplayString);
    });

    test(
        'Given a light mode ThemeMode, '
        'when converting that ThemeMode to a display string, '
        'then the correct display string should be returned.', () {
      const lightMode = ThemeMode.light;
      const expectedDisplayString =
          ThemeModeConstants.lightThemeModeDisplayString;

      final actualDisplayString = lightMode.toDisplayString();

      expect(actualDisplayString, expectedDisplayString);
    });

    test(
        'Given a system mode ThemeMode, '
        'when converting that ThemeMode to a display string, '
        'then the correct display string should be returned.', () {
      const systemMode = ThemeMode.system;
      const expectedDisplayString =
          ThemeModeConstants.systemThemeModeDisplayString;

      final actualDisplayString = systemMode.toDisplayString();

      expect(actualDisplayString, expectedDisplayString);
    });
  });
}
