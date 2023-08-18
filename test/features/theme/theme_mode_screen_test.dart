// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'package:cartalogue/core/core.dart';
import 'package:cartalogue/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ThemeScreen', () {
    testWidgets(
        'Given a saved ThemeMode on Shared Preferences, '
        'when the screen is built, '
        'then the initial brightness should be the saved ThemeMode\'s brightness.',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        ThemeModeConstants.selectedThemeKey: ThemeModeConstants.darkThemeMode,
      });
      final sharedPreferences = await SharedPreferences.getInstance();
      final sharedPreferencesService = SharedPreferencesService(
        sharedPreferences,
      );

      await tester.pumpApp(
        sharedPreferencesService: sharedPreferencesService,
        ThemeModeScreen(),
      );
      final theme = Theme.of(tester.element(find.byType(ThemeModeScreen)));

      expect(
        theme.brightness,
        equals(Brightness.dark),
      );
    });
  });
  testWidgets(
      'Given a ThemeModeController, '
      'when a ThemeMode is selected, '
      'then the brightness should be the selected ThemeMode\'s brightness.',
      (tester) async {
    final initiaThemeKey = ThemeModeConstants.darkThemeMode;

    SharedPreferences.setMockInitialValues({
      ThemeModeConstants.selectedThemeKey: initiaThemeKey,
    });
    final sharedPreferences = await SharedPreferences.getInstance();
    final sharedPreferencesService = SharedPreferencesService(
      sharedPreferences,
    );

    await tester.pumpApp(
      sharedPreferencesService: sharedPreferencesService,
      ThemeModeScreen(),
    );

    final allTiles = find.byType(ThemeCard);
    final lightModeTile = allTiles.at(1);

    await tester.tap(lightModeTile);

    await tester.pump();
    await tester.pumpAndSettle();

    final actual = sharedPreferences.getString(
      ThemeModeConstants.selectedThemeKey,
    )!;

    expect(actual, equals(ThemeModeConstants.lightThemeMode));
  });
}
