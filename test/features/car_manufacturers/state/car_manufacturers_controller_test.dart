import 'package:cartalogue/core/core.dart';
import 'package:cartalogue/features/features.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/helpers.dart';

void main() {
  late Dio dio;

  group('CarManufacturersController', () {
    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      dio = Dio();
    });

    test(
        'Given a CarManufacturersController, a locally saved list of CarManufacturers and no internet connection, '
        'when the state is initialized, '
        'then the local list of CarManufacturers is loaded.', () async {
      // Given
      final fakeManufacturersList = [
        const CarManufacturerModel(
            name: 'Chevrolet',
            countryName: 'United States',
            fullName: 'Chevrolet',
            id: 1),
        const CarManufacturerModel(
            name: 'Ford',
            countryName: 'United States',
            fullName: 'Ford',
            id: 2),
        const CarManufacturerModel(
            name: 'Honda', countryName: 'Japan', fullName: 'Honda', id: 3),
        const CarManufacturerModel(
            name: 'Hyundai',
            countryName: 'South Korea',
            fullName: 'Hyundai',
            id: 4),
      ];

      final savedList = fakeManufacturersList.map((e) => e.toJson()).toList();
      SharedPreferences.setMockInitialValues({
        SharedPreferencesAndNHTSACarManufacturersService
            .savedCarManufacturersKey: savedList,
      });
      final mockPreferences = await SharedPreferences.getInstance();

      final mockSharedPreferencesService = SharedPreferencesService(
        mockPreferences,
      );

      final mockConnectivity = MockConnectivity(
        connectivityCase: ConnectivityCase.error,
      );

      final service = SharedPreferencesAndNHTSACarManufacturersService(
        dio,
        mockSharedPreferencesService,
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider
              .overrideWithValue(mockSharedPreferencesService),
          carManufacturersServiceProvider.overrideWithValue(service),
          connectivityProvider.overrideWithValue(mockConnectivity),
        ],
      );
      addTearDown(container.dispose);

      // When
      final controller =
          container.read(carManufacturersControllerProvider.notifier);
      final state = container.read(carManufacturersControllerProvider);

      // Then
      expect(
        state,
        isA<CarManufacturersState>(),
      );

      final capturedState = await controller.stream.firstWhere(
        (state) => state.carManufacturers is AsyncData,
      );

      final expectedManufacturers =
          capturedState.carManufacturers.asData?.value.values.toList();

      expect(
        expectedManufacturers,
        fakeManufacturersList,
      );
    });

    test(
      'Given a CarManufacturersController and internet connection, '
      'When the state is initialized, '
      'Then the remote list of CarManufacturers is loaded.',
      () async {
        // Given
        final fakeManifacturerRemoteEntities = [
          const CarManufacturerRemoteEntity(
            name: 'Chevrolet',
            country: 'United States',
            vehicleTypes: [],
            id: 1,
          ),
        ];
        final fakeManufacturersList = fakeManifacturerRemoteEntities
            .map((e) => CarManufacturerModel.fromRemoteEntity(e))
            .toList();
        final mockCarManufacturersService = MockCarManufacturersService();

        when(() => mockCarManufacturersService.fetchCarManufacturersRemotely(
              page: any(named: 'page'),
            )).thenAnswer((invocation) => Future.value(
              fakeManufacturersList,
            ));
        when(() =>
                mockCarManufacturersService.fetchLocallySavedCarManufacturers())
            .thenAnswer((invocation) => Future.value(
                  fakeManufacturersList,
                ));

        when(() => mockCarManufacturersService.saveCarManufacturersLocally(
              carManufacturers: any(named: 'carManufacturers'),
            )).thenAnswer((invocation) => Future.value());

        final mockConnectivity = MockConnectivity(
          connectivityCase: ConnectivityCase.success,
        );

        final container = ProviderContainer(
          overrides: [
            carManufacturersServiceProvider
                .overrideWithValue(mockCarManufacturersService),
            connectivityProvider.overrideWithValue(mockConnectivity),
          ],
        );
        addTearDown(container.dispose);

        // When
        final controller =
            container.read(carManufacturersControllerProvider.notifier);
        final state = container.read(carManufacturersControllerProvider);

        // Then
        expect(
          state,
          isA<CarManufacturersState>(),
        );

        final capturedState = await controller.stream.firstWhere(
          (state) => state.carManufacturers is AsyncData,
        );

        final expectedManufacturers =
            capturedState.carManufacturers.asData?.value.values.toList();

        expect(
          expectedManufacturers,
          fakeManufacturersList,
        );
      },
    );
  });
}
