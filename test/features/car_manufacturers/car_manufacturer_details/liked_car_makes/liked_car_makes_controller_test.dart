import 'package:cartalogue/core/core.dart';
import 'package:cartalogue/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('LikedCarMakesController', () {
    test(
        'Given no saved liked car makes, '
        'when the controller is initialized, '
        'then the state should be an empty set', () async {
      final sharedPreferencesService = MockSharedPreferencesService();

      when(
        () => sharedPreferencesService.getListOfStringsFromSharedPreferences(
          any(),
        ),
      ).thenAnswer(
        (_) => null,
      );

      when(() => sharedPreferencesService.saveListOfStringsToSharedPreferences(
            any(),
            any(),
          )).thenAnswer(
        (_) async => true,
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            sharedPreferencesService,
          ),
        ],
      );

      final state = container.read(likedCarMakesControllerProvider);

      expect(state, isEmpty);
    });

    test(
      'Given a saved liked car makes list, '
      'when the controller is initialized, '
      'then the state should be a set of car makes',
      () async {
        SharedPreferences.setMockInitialValues({
          'liked_car_makes': [
            '{"id":1,"name":"Mini"}',
            '{"id":2,"name":"BMW"}',
          ],
        });

        final mockPreferences = await SharedPreferences.getInstance();

        final mockSharedPreferencesService = SharedPreferencesService(
          mockPreferences,
        );

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesServiceProvider.overrideWithValue(
              mockSharedPreferencesService,
            ),
          ],
        );

        final state = container.read(likedCarMakesControllerProvider);

        expect(state, isA<Set<CarMakeModel>>());
        expect(state, hasLength(2));
        expect(state, contains(const CarMakeModel(id: 1, name: 'Mini')));
        expect(state, contains(const CarMakeModel(id: 2, name: 'BMW')));
      },
    );

    test(
        'Given a CarMakeModel, '
        'when onCarMakeLiked is called, '
        'then the state should contain the CarMakeModel', () {
      final sharedPreferencesService = MockSharedPreferencesService();

      when(
        () => sharedPreferencesService.getListOfStringsFromSharedPreferences(
          any(),
        ),
      ).thenAnswer(
        (_) => null,
      );

      when(() => sharedPreferencesService.saveListOfStringsToSharedPreferences(
            any(),
            any(),
          )).thenAnswer(
        (_) async => true,
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            sharedPreferencesService,
          ),
        ],
      );

      final controller =
          container.read(likedCarMakesControllerProvider.notifier);

      const carMake = CarMakeModel(id: 1, name: 'Mini');

      controller.onCarMakeLiked(carMake);

      final state = container.read(likedCarMakesControllerProvider);

      expect(state, contains(carMake));
    });

    test(
      'Given a CarMakeModel, '
      'when onCarMakeLiked is called, '
      'then the value should be saved to shared preferences.',
      () async {
        final sharedPreferencesService = MockSharedPreferencesService();

        when(
          () => sharedPreferencesService.getListOfStringsFromSharedPreferences(
            any(),
          ),
        ).thenAnswer(
          (_) => null,
        );

        when(
            () => sharedPreferencesService.saveListOfStringsToSharedPreferences(
                  any(),
                  any(),
                )).thenAnswer(
          (_) async => true,
        );

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesServiceProvider.overrideWithValue(
              sharedPreferencesService,
            ),
          ],
        );

        final controller =
            container.read(likedCarMakesControllerProvider.notifier);

        const carMake = CarMakeModel(id: 1, name: 'Mini');

        controller.onCarMakeLiked(carMake);

        // Expect `saveListOfStringsToSharedPreferences` to be called twice:
        //  1. When the controller is initialized and the state is an empty set.
        //  2. When onCarMakeLiked is called and the state is updated.
        verify(
          () => sharedPreferencesService.saveListOfStringsToSharedPreferences(
            any(),
            any(),
          ),
        ).called(2);
      },
    );
  });
}
