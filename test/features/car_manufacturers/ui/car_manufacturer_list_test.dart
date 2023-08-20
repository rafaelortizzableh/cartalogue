import 'package:cartalogue/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cartalogue/features/features.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('CarManufacturerList', () {
    testWidgets(
        'Given a CarManufacturerList, '
        'when it is rendered, '
        'then it should display a list of CarManufacturerCard.',
        (tester) async {
      final carManufacturers = {
        1: const CarManufacturerModel(
          id: 1,
          name: 'Audi',
          countryName: 'Germany',
          fullName: 'Audi',
        ),
        2: const CarManufacturerModel(
          id: 2,
          name: 'BMW',
          countryName: 'Germany',
          fullName: 'Bayerische Motoren Werke AG',
        ),
      };

      final carManufacturerState = CarManufacturersState(
        carManufacturers: AsyncValue.data(carManufacturers),
        isDeviceOnline: true,
        isLoadingMore: false,
        hasReachedMax: false,
      );

      final mockController = MockCarManufacturersController(
        carManufacturerState,
      );

      await tester.pumpApp(
        const CarManufacturersList(),
        overrides: [
          carManufacturersControllerProvider.overrideWith(
            (_) => mockController,
          ),
        ],
      );

      expect(find.byType(CarManufacturerCard), findsNWidgets(2));
    });

    testWidgets(
      'Given no CarManifacturerModels, '
      'when the list is being loaded, '
      'then it should display a CircularProgressIndicator.',
      (tester) async {
        const carManufacturerState = CarManufacturersState(
          carManufacturers: AsyncValue.loading(),
          isDeviceOnline: true,
          isLoadingMore: false,
          hasReachedMax: false,
        );

        final mockController = MockCarManufacturersController(
          carManufacturerState,
        );

        await tester.pumpApp(
          const CarManufacturersList(),
          overrides: [
            carManufacturersControllerProvider.overrideWith(
              (_) => mockController,
            ),
          ],
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
        'Given an existing list of CarManufacturerModel, '
        'when there is more data being loaded, '
        'then it should display a CircularProgressIndicator.', (tester) {
      final carManufacturers = {
        1: const CarManufacturerModel(
          id: 1,
          name: 'Audi',
          countryName: 'Germany',
          fullName: 'Audi',
        ),
        2: const CarManufacturerModel(
          id: 2,
          name: 'BMW',
          countryName: 'Germany',
          fullName: 'Bayerische Motoren Werke AG',
        ),
      };

      final carManufacturerState = CarManufacturersState(
        carManufacturers: AsyncValue.data(carManufacturers),
        isDeviceOnline: true,
        isLoadingMore: true,
        hasReachedMax: false,
      );

      final mockController = MockCarManufacturersController(
        carManufacturerState,
      );

      return tester.pumpApp(
        const CarManufacturersList(),
        overrides: [
          carManufacturersControllerProvider.overrideWith(
            (_) => mockController,
          ),
        ],
      ).then((_) {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    testWidgets(
        'Given an existing list of CarManufacturerModel, '
        'when there is more data to be loaded, '
        'then it should display a button with the text "Load more".',
        (tester) async {
      final carManufacturers = {
        1: const CarManufacturerModel(
          id: 1,
          name: 'Audi',
          countryName: 'Germany',
          fullName: 'Audi',
        ),
        2: const CarManufacturerModel(
          id: 2,
          name: 'BMW',
          countryName: 'Germany',
          fullName: 'Bayerische Motoren Werke AG',
        ),
      };

      final carManufacturerState = CarManufacturersState(
        carManufacturers: AsyncValue.data(carManufacturers),
        isDeviceOnline: true,
        isLoadingMore: false,
        hasReachedMax: false,
      );

      final mockController = MockCarManufacturersController(
        carManufacturerState,
      );

      await tester.pumpApp(
        const CarManufacturersList(),
        overrides: [
          carManufacturersControllerProvider.overrideWith(
            (_) => mockController,
          ),
          isNetworkConnectedProvider.overrideWithValue(true),
        ],
      );

      expect(find.text('Load more'), findsOneWidget);
    });

    testWidgets(
        'Given an existing list of CarManufacturerModel, '
        'when there is no more data to be loaded, '
        'then it should display the text "No more manufacturers to load".',
        (tester) async {
      final carManufacturers = {
        1: const CarManufacturerModel(
          id: 1,
          name: 'Audi',
          countryName: 'Germany',
          fullName: 'Audi',
        ),
        2: const CarManufacturerModel(
          id: 2,
          name: 'BMW',
          countryName: 'Germany',
          fullName: 'Bayerische Motoren Werke AG',
        ),
      };

      final carManufacturerState = CarManufacturersState(
        carManufacturers: AsyncValue.data(carManufacturers),
        isDeviceOnline: true,
        isLoadingMore: false,
        hasReachedMax: true,
        lastRemotePageFetched: 1,
      );

      final mockController = MockCarManufacturersController(
        carManufacturerState,
      );

      await tester.pumpApp(
        const CarManufacturersList(),
        overrides: [
          carManufacturersControllerProvider.overrideWith(
            (_) => mockController,
          ),
          isNetworkConnectedProvider.overrideWithValue(true),
        ],
      );

      expect(find.text('No more manufacturers to load'), findsOneWidget);
    });

    testWidgets(
        'Given an existing list of CarManufacturerModel, '
        'when there is no internet connection, '
        'then it should display the text "No internet connection".',
        (tester) async {
      final carManufacturers = {
        1: const CarManufacturerModel(
          id: 1,
          name: 'Audi',
          countryName: 'Germany',
          fullName: 'Audi',
        ),
        2: const CarManufacturerModel(
          id: 2,
          name: 'BMW',
          countryName: 'Germany',
          fullName: 'Bayerische Motoren Werke AG',
        ),
      };

      final carManufacturerState = CarManufacturersState(
        carManufacturers: AsyncValue.data(carManufacturers),
        isDeviceOnline: false,
        isLoadingMore: false,
        hasReachedMax: true,
        lastRemotePageFetched: 1,
      );

      final mockController = MockCarManufacturersController(
        carManufacturerState,
      );

      await tester.pumpApp(
        const CarManufacturersList(),
        overrides: [
          carManufacturersControllerProvider.overrideWith(
            (_) => mockController,
          ),
          isNetworkConnectedProvider.overrideWithValue(false),
        ],
      );

      expect(find.text('No internet connection'), findsOneWidget);
    });

    testWidgets(
        'Given an error state, '
        'when the list is rendered, '
        'then it should display an ErrorLoadingManufacturers widget.',
        (tester) async {
      const carManufacturerState = CarManufacturersState(
        carManufacturers: AsyncValue.error('Error', StackTrace.empty),
        isDeviceOnline: true,
        isLoadingMore: false,
        hasReachedMax: false,
      );

      final mockController = MockCarManufacturersController(
        carManufacturerState,
      );

      await tester.pumpApp(
        const CarManufacturersList(),
        overrides: [
          carManufacturersControllerProvider.overrideWith(
            (_) => mockController,
          ),
        ],
      );

      expect(find.byType(ErrorLoadingManufacturers), findsOneWidget);
    });
  });
}
