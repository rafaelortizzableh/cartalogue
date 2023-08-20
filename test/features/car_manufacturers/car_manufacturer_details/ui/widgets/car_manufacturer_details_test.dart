import 'package:cartalogue/features/features.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('CarManufacturerDetails', () {
    testWidgets(
      'Given a list of car makes, '
      'When the widget is rendered, '
      'Then the CarMakesList is rendered',
      (tester) async {
        final carMakes = [
          const CarMakeModel(
            id: 1,
            name: 'Mini',
          ),
          const CarMakeModel(
            id: 2,
            name: 'BMW',
          ),
        ];

        await tester.pumpApp(
          CustomScrollView(
            slivers: [
              CarManufacturerDetails(
                manufacturerName: 'BMW Group',
                carMakes: carMakes,
              ),
            ],
          ),
        );

        expect(find.byType(CarMakeTile), findsNWidgets(carMakes.length));
      },
    );

    testWidgets(
      'Given an empty list of car makes, '
      'When the widget is rendered, '
      'Then the EmptyCarMakes is rendered',
      (tester) async {
        await tester.pumpApp(
          const CustomScrollView(
            slivers: [
              CarManufacturerDetails(
                manufacturerName: 'BMW Group',
                carMakes: [],
              ),
            ],
          ),
        );

        expect(find.byType(EmptyCarMakes), findsOneWidget);
      },
    );

    testWidgets(
      'Given a list of car makes, '
      'when a car make is tapped, '
      'then a modal bottom sheet is rendered.',
      (tester) async {
        final carMakes = [
          const CarMakeModel(
            id: 1,
            name: 'Mini',
          ),
          const CarMakeModel(
            id: 2,
            name: 'BMW',
          ),
        ];

        await tester.pumpApp(
          CustomScrollView(
            slivers: [
              CarManufacturerDetails(
                manufacturerName: 'BMW Group',
                carMakes: carMakes,
              ),
            ],
          ),
        );

        await tester.tap(find.byType(CarMakeTile).first);
        await tester.pumpAndSettle();

        expect(
          find.byType(CarMakeDetailBottomSheet),
          findsOneWidget,
        );
      },
    );
  });
}
