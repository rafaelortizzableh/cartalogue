import 'package:cartalogue/core/core.dart';
import 'package:cartalogue/features/features.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../helpers/helpers.dart';

void main() {
  group('LikeCarMakeIconButton', () {
    late final ColorScheme colorScheme;
    late final CarMakeModel carMake;

    setUpAll(() {
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      carMake = const CarMakeModel(
        id: 1,
        name: 'BMW',
      );
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        LikeCarMakeIconButton(
          colorScheme: colorScheme,
          carMake: carMake,
        ),
      );
      expect(find.byType(AnimatedScale), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets(
        'Given a list of liked car makes, '
        'When the car make is liked, '
        'Then the icon is filled', (tester) async {
      await tester.pumpApp(
        LikeCarMakeIconButton(
          colorScheme: colorScheme,
          carMake: carMake,
        ),
      );
      expect(find.byIcon(CupertinoIcons.heart), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.heart_fill), findsNothing);
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byIcon(CupertinoIcons.heart), findsNothing);
      expect(find.byIcon(CupertinoIcons.heart_fill), findsOneWidget);
    });

    testWidgets(
        'Given a list of liked car makes, '
        'When the car make is unliked, '
        'Then the icon is not filled', (tester) async {
      SharedPreferences.setMockInitialValues({
        'liked_car_makes': [carMake.id],
      });

      final sharedPreferencesService = MockSharedPreferencesService();

      when(() => sharedPreferencesService.getListOfStringsFromSharedPreferences(
            any(),
          )).thenAnswer(
        (_) => [carMake.toJson()],
      );

      when(() => sharedPreferencesService.saveListOfStringsToSharedPreferences(
            any(),
            any(),
          )).thenAnswer(
        (_) async => true,
      );

      await tester.pumpApp(
        LikeCarMakeIconButton(
          colorScheme: colorScheme,
          carMake: carMake,
        ),
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            sharedPreferencesService,
          ),
        ],
      );

      expect(find.byIcon(CupertinoIcons.heart), findsNothing);
      expect(find.byIcon(CupertinoIcons.heart_fill), findsOneWidget);
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byIcon(CupertinoIcons.heart), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.heart_fill), findsNothing);
    });

    testWidgets(
        'Given a list of liked car makes with the car make liked, '
        'When the widget is built, '
        'Then the icon is filled.', (tester) async {
      SharedPreferences.setMockInitialValues({
        'liked_car_makes': [carMake.id],
      });

      final sharedPreferencesService = MockSharedPreferencesService();

      when(() => sharedPreferencesService.getListOfStringsFromSharedPreferences(
            any(),
          )).thenAnswer(
        (_) => [carMake.toJson()],
      );
      when(() => sharedPreferencesService.saveListOfStringsToSharedPreferences(
            any(),
            any(),
          )).thenAnswer(
        (_) async => true,
      );

      await tester.pumpApp(
        LikeCarMakeIconButton(
          colorScheme: colorScheme,
          carMake: carMake,
        ),
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            sharedPreferencesService,
          ),
        ],
      );
      expect(find.byIcon(CupertinoIcons.heart), findsNothing);
      expect(find.byIcon(CupertinoIcons.heart_fill), findsOneWidget);
    });
  });
}
