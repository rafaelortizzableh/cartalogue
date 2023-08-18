import 'package:cartalogue/core/core.dart';
import 'package:cartalogue/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeModeService', () {
    test(
      'Given a ThemeModeService, '
      'when updating the theme mode, '
      'then that theme should be saved to SharesPreferences.',
      () async {
        // Given
        SharedPreferences.setMockInitialValues({});
        final mockPreferences = await SharedPreferences.getInstance();
        final mockSharedPreferencesService =
            SharedPreferencesService(mockPreferences);
        final themeService = ThemeModeService(
          mockSharedPreferencesService,
        );

        const themeMode = ThemeMode.dark;

        // When
        await themeService.updateThemeMode(themeMode);

        // Then
        final savedTheme = mockSharedPreferencesService
            .getStringFromSharedPreferences(ThemeModeConstants.selectedThemeKey)
            .toThemeMode();
        expect(savedTheme, themeMode);
      },
    );

    test(
        'Given a ThemeModeService, '
        'when getting the saved theme mode, '
        'then the correct theme mode should be returned.', () async {
      // Given
      SharedPreferences.setMockInitialValues({
        ThemeModeConstants.selectedThemeKey: ThemeModeConstants.darkThemeMode,
      });
      final mockPreferences = await SharedPreferences.getInstance();
      final mockSharedPreferencesService =
          SharedPreferencesService(mockPreferences);
      final themeService = ThemeModeService(
        mockSharedPreferencesService,
      );

      const themeMode = ThemeMode.dark;

      // When
      final savedTheme = themeService.getSavedThemeMode();

      // Then
      expect(savedTheme, themeMode);
    });
  });
}
