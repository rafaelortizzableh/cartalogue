import 'package:cartalogue/features/features.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('CarManufacturerDetailsScreen', () {
    testWidgets(
      'renders NoSelectedCarManufacturer when no car manufacturer is selected',
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

        expect(find.byType(NoSelectedCarManufacturer), findsOneWidget);
      },
    );

    testWidgets(
      'renders NoSelectedCarManufacturer when no car manufacturer name is found',
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

        expect(find.byType(NoSelectedCarManufacturer), findsOneWidget);
      },
    );

    testWidgets(
      'renders CarManufacturerDetails when a car manufacturer is selected',
      (tester) async {
        const mockCarManifacturersDetailsState = CarManufacturerDetailsState(
          manufacturerId: 1,
          manufacturerName: 'Audi',
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

        expect(find.byType(CarManufacturerDetails), findsOneWidget);
      },
    );
  });
}
