import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import 'theme.dart';

/// The [Provider] for the [ThemeModeService].
final themeModeServiceProvider = Provider<ThemeModeService>(
  (ref) => ThemeModeService(ref.watch(sharedPreferencesServiceProvider)),
);

/// A service that stores and retrieves
/// the user's prefered theme mode locally.
class ThemeModeService {
  const ThemeModeService(this._sharedPreferencesService);

  final SharedPreferencesService _sharedPreferencesService;

  /// Loads the User's preferred ThemeMode from local or remote storage.
  ThemeMode getSavedThemeMode() {
    final savedThemeModeValue =
        _sharedPreferencesService.getStringFromSharedPreferences(
      ThemeModeConstants.selectedThemeKey,
    );

    return savedThemeModeValue.toThemeMode();
  }

  /// Saves the User's preferred ThemeMode to local storage.
  Future<bool> updateThemeMode(ThemeMode theme) async {
    switch (theme) {
      case ThemeMode.light:
        return await _sharedPreferencesService.save(
          ThemeModeConstants.selectedThemeKey,
          ThemeModeConstants.lightThemeMode,
        );
      case ThemeMode.dark:
        return await _sharedPreferencesService.save(
          ThemeModeConstants.selectedThemeKey,
          ThemeModeConstants.darkThemeMode,
        );
      case ThemeMode.system:
        return await _sharedPreferencesService.save(
          ThemeModeConstants.selectedThemeKey,
          ThemeModeConstants.systemThemeMode,
        );
    }
  }
}
