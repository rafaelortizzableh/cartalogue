// ignore_for_file: prefer_const_constructors

import 'package:cartalogue/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(
    'CarManufacturerDetailsController',
    () {
      late CarManufacturersService carManufacturersService;
      TestWidgetsFlutterBinding.ensureInitialized();

      setUpAll(() {
        registerFallbackValue(Uri());
      });
      setUp(() {
        carManufacturersService = MockCarManufacturersService();
      });
      test(
        'Given a CarManufacturerDetailsController, '
        'when the state is initialized, '
        'then the car makes are loaded.',
        () async {
          // Given
          final carMakes = [
            const CarMakeModel(
              id: 1,
              name: 'Chevrolet',
            ),
            const CarMakeModel(
              id: 2,
              name: 'Camaro',
            ),
            const CarMakeModel(
              id: 3,
              name: 'Corvette',
            ),
          ];

          final selectedCarManufacturer = CarManufacturerModel(
            id: 1,
            name: 'Chevrolet',
            countryName: 'United States',
            fullName: 'Chevrolet',
          );

          final carManufacturersController = MockCarManufacturersController(
            CarManufacturersState(
              selectedManufacturerId: 1,
              carManufacturers: AsyncData(
                {
                  1: selectedCarManufacturer,
                },
              ),
            ),
          );

          when(
            () => carManufacturersService.getCarMakes(any()),
          ).thenAnswer(
            (_) async => carMakes,
          );

          final container = ProviderContainer(
            overrides: [
              carManufacturersServiceProvider.overrideWithValue(
                carManufacturersService,
              ),
              carManufacturersControllerProvider.overrideWith(
                (_) => carManufacturersController,
              ),
              selectedCarManufacturerProvider.overrideWithValue(
                selectedCarManufacturer,
              ),
            ],
          );

          // When
          final controller =
              container.read(carManufacturerDetailsProvider.notifier);

          // Then
          final capturedState = await controller.stream
              .firstWhere((element) => element.carMakes is AsyncData);

          final expectedCarMakes =
              capturedState.carMakes.asData?.value.values.toList();

          expect(expectedCarMakes, equals(carMakes));
        },
      );
    },
  );
}
