import 'package:cartalogue/features/features.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CarMakeModel', () {
    test('should be equatable', () {
      const carMakeModel1 = CarMakeModel(id: 1, name: 'name');
      const carMakeModel2 = CarMakeModel(id: 1, name: 'name');

      expect(carMakeModel1, carMakeModel2);
    });

    test('should be able to convert from json', () {
      const carMakeModel = CarMakeModel(id: 1, name: 'name');
      const jsonString = '{"id":1,"name":"name"}';

      expect(CarMakeModel.fromJson(jsonString), carMakeModel);
    });

    test('should be able to convert to json', () {
      const carMakeModel = CarMakeModel(id: 1, name: 'name');
      const jsonString = '{"id":1,"name":"name"}';

      expect(carMakeModel.toJson(), jsonString);
    });

    test('should be able to convert from remote entity', () {
      const carMakeModel = CarMakeModel(id: 1, name: 'name');
      const remoteEntity = CarMakeRemoteEntity(
        makeId: 1,
        makeName: 'name',
        mfrName: 'mfrName',
      );

      expect(CarMakeModel.fromRemoteEntity(remoteEntity), carMakeModel);
    });

    test('should be able to convert to map', () {
      const carMakeModel = CarMakeModel(id: 1, name: 'name');
      const map = {'id': 1, 'name': 'name'};

      expect(carMakeModel.toMap(), map);
    });

    test('should be able to convert from map', () {
      const carMakeModel = CarMakeModel(id: 1, name: 'name');
      const map = {'id': 1, 'name': 'name'};

      expect(CarMakeModel.fromMap(map), carMakeModel);
    });
  });
}
