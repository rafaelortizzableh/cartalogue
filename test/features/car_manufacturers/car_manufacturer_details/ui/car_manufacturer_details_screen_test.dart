import 'package:cartalogue/core/core.dart';
import 'package:cartalogue/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('CarManufacturerDetailsScreen', () {
    testWidgets(
      'renders ErrorGettingCarManufacturerDetails when no car manufacturer is selected',
      (tester) async {
        const mockCarManifacturersDetailsState = CarManufacturerDetailsState(
          manufacturerId: null,
        );

        final mockCarManufacturersController =
            MockCarManufacturerDetailsController(
          mockCarManifacturersDetailsState,
        );
        await tester.pumpApp(const CarManufacturerDetailsScreen(), overrides: [
          carManufacturerDetailsProvider.overrideWith(
            (_) => mockCarManufacturersController,
          ),
        ]);

        expect(find.byType(ErrorGettingCarManufacturerDetails), findsOneWidget);
      },
    );

    testWidgets(
      'renders ErrorGettingCarManufacturerDetails when no car manufacturer name is found',
      (tester) async {
        const mockCarManifacturersDetailsState = CarManufacturerDetailsState(
          manufacturerName: null,
          manufacturerId: 1,
        );

        final mockCarManufacturersController =
            MockCarManufacturerDetailsController(
          mockCarManifacturersDetailsState,
        );
        await tester.pumpApp(const CarManufacturerDetailsScreen(), overrides: [
          carManufacturerDetailsProvider.overrideWith(
            (_) => mockCarManufacturersController,
          ),
        ]);

        expect(find.byType(ErrorGettingCarManufacturerDetails), findsOneWidget);
      },
    );

    testWidgets(
      'renders ErrorGettingCarManufacturerDetails when there\'s a network error',
      (tester) async {
        const mockCarManifacturersDetailsState = CarManufacturerDetailsState(
          manufacturerName: 'Mazda',
          manufacturerId: 1,
          carMakes: AsyncError(NHTSAApiRequestFailure, StackTrace.empty),
        );

        final mockCarManufacturersController =
            MockCarManufacturerDetailsController(
          mockCarManifacturersDetailsState,
        );
        await tester.pumpApp(const CarManufacturerDetailsScreen(), overrides: [
          carManufacturerDetailsProvider.overrideWith(
            (_) => mockCarManufacturersController,
          ),
        ]);

        expect(find.byType(ErrorGettingCarManufacturerDetails), findsOneWidget);
      },
    );

    testWidgets(
      'renders CarManufacturerDetails when a car manufacturer is selected',
      (tester) async {
        const mockCarManifacturersDetailsState = CarManufacturerDetailsState(
          manufacturerId: 1,
          manufacturerName: 'Audi',
          carMakes: AsyncData(
            {
              1: CarMakeModel(id: 1, name: 'Audi'),
            },
          ),
        );

        final mockCarManufacturersController =
            MockCarManufacturerDetailsController(
          mockCarManifacturersDetailsState,
        );
        await tester.pumpApp(
          const CarManufacturerDetailsScreen(),
          overrides: [
            carManufacturerDetailsProvider.overrideWith(
              (_) => mockCarManufacturersController,
            ),
          ],
        );

        expect(find.byType(CarManufacturerDetails), findsOneWidget);
      },
    );

    testWidgets(
      'renders GenericLoader when car makes are loading',
      (tester) async {
        const mockCarManifacturersDetailsState = CarManufacturerDetailsState(
          manufacturerId: 1,
          manufacturerName: 'Audi',
          carMakes: AsyncLoading(),
        );

        final mockCarManufacturersController =
            MockCarManufacturerDetailsController(
          mockCarManifacturersDetailsState,
        );
        await tester.pumpApp(
          const CarManufacturerDetailsScreen(),
          overrides: [
            carManufacturerDetailsProvider.overrideWith(
              (_) => mockCarManufacturersController,
            ),
          ],
        );

        expect(find.byType(GenericLoader), findsOneWidget);
      },
    );
  });
}
