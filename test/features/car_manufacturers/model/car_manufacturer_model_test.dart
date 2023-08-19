import 'package:cartalogue/features/features.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CarManufacturerModel', () {
    test('can be instantiated', () {
      const model = CarManufacturerModel(
        countryName: 'UNITED STATES (USA)',
        fullName: 'A-1 CUSTOM TRAILER MFG., INC. ',
        id: 1183,
        name: 'Tow Master',
      );
      expect(model, isA<CarManufacturerModel>());
    });

    test('equality comparison works', () {
      const model = CarManufacturerModel(
        countryName: 'UNITED STATES (USA)',
        fullName: 'A-1 CUSTOM TRAILER MFG., INC. ',
        id: 1183,
        name: 'Tow Master',
      );
      const model2 = CarManufacturerModel(
        countryName: 'UNITED STATES (USA)',
        fullName: 'A-1 CUSTOM TRAILER MFG., INC. ',
        id: 1183,
        name: 'Tow Master',
      );
      expect(model, model2);
    });

    test('can be (de)serialized', () {
      const response = CarManufacturerModel(
        countryName: 'UNITED STATES (USA)',
        fullName: 'A-1 CUSTOM TRAILER MFG., INC. ',
        id: 1183,
        name: 'Tow Master',
      );

      expect(
        CarManufacturerModel.fromJson(response.toJson()),
        equals(response),
      );
    });

    test('can be instantiated from a remote entity', () {
      const entity = CarManufacturerRemoteEntity(
        country: 'UNITED STATES (USA)',
        id: 1183,
        name: 'Tow Master',
        vehicleTypes: [
          VehicleTypeRemoteEntity(
            isPrimary: false,
            name: 'Trailer',
          ),
        ],
      );

      expect(
        CarManufacturerModel.fromRemoteEntity(entity),
        isA<CarManufacturerModel>(),
      );
    });
  });
}
