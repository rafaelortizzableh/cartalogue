import 'package:cartalogue/features/features.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CarManufacturerRemoteEntity', () {
    test('can be deserialized', () {
      const json =
          '{"Country": "UNITED STATES (USA)","Mfr_CommonName": null,"Mfr_ID": 1178,"Mfr_Name": "3T MFG.","VehicleTypes": [{"IsPrimary": false,"Name": "Trailer"},{"IsPrimary": false,"Name": "Incomplete Vehicle"}]}';
      final entity = CarManufacturerRemoteEntity.fromJson(json);
      expect(entity, isA<CarManufacturerRemoteEntity>());
    });

    test('equality comparison works', () {
      const json =
          '{"Country": "UNITED STATES (USA)","Mfr_CommonName": null,"Mfr_ID": 1178,"Mfr_Name": "3T MFG.","VehicleTypes": [{"IsPrimary": false,"Name": "Trailer"},{"IsPrimary": false,"Name": "Incomplete Vehicle"}]}';
      final entity = CarManufacturerRemoteEntity.fromJson(json);
      const entity2 = CarManufacturerRemoteEntity(
        country: 'UNITED STATES (USA)',
        id: 1178,
        name: '3T MFG.',
        vehicleTypes: [
          VehicleTypeRemoteEntity(
            isPrimary: false,
            name: 'Trailer',
          ),
          VehicleTypeRemoteEntity(
            isPrimary: false,
            name: 'Incomplete Vehicle',
          ),
        ],
      );
      expect(entity, entity2);
    });
  });
}
