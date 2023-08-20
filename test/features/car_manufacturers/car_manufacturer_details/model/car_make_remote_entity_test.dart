import 'package:cartalogue/features/features.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CarMakeRemoteEntity', () {
    test('should be equatable', () {
      const carMakeRemoteEntity1 = CarMakeRemoteEntity(
        makeId: 1,
        makeName: 'name',
        mfrName: 'mfrName',
      );
      const carMakeRemoteEntity2 = CarMakeRemoteEntity(
        makeId: 1,
        makeName: 'name',
        mfrName: 'mfrName',
      );

      expect(carMakeRemoteEntity1, carMakeRemoteEntity2);
    });

    test('should be able to convert from json', () {
      const carMakeRemoteEntity = CarMakeRemoteEntity(
        makeId: 1,
        makeName: 'name',
        mfrName: 'mfrName',
      );
      const jsonString =
          '{"Make_ID":1,"Make_Name":"name","Mfr_Name":"mfrName"}';

      expect(CarMakeRemoteEntity.fromJson(jsonString), carMakeRemoteEntity);
    });

    test('should be able to convert to json', () {
      const carMakeRemoteEntity = CarMakeRemoteEntity(
        makeId: 1,
        makeName: 'name',
        mfrName: 'mfrName',
      );
      const jsonString =
          '{"Make_ID":1,"Make_Name":"name","Mfr_Name":"mfrName"}';

      expect(carMakeRemoteEntity.toJson(), jsonString);
    });
  });

  test('should be able to convert to map', () {
    const carMakeRemoteEntity = CarMakeRemoteEntity(
      makeId: 1,
      makeName: 'name',
      mfrName: 'mfrName',
    );
    const map = {
      'Make_ID': 1,
      'Make_Name': 'name',
      'Mfr_Name': 'mfrName',
    };

    expect(carMakeRemoteEntity.toMap(), map);
  });

  test('should be able to convert from map', () {
    const carMakeRemoteEntity = CarMakeRemoteEntity(
      makeId: 1,
      makeName: 'name',
      mfrName: 'mfrName',
    );
    const map = {
      'Make_ID': 1,
      'Make_Name': 'name',
      'Mfr_Name': 'mfrName',
    };

    expect(CarMakeRemoteEntity.fromMap(map), carMakeRemoteEntity);
  });
}
