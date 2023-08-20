import 'package:cartalogue/core/core.dart';
import 'package:cartalogue/features/features.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CarManufacturersService', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
    });

    test(
      'Given a SharedPreferences instance with a list of car manufacturers, '
      'when fetchLocallySavedCarManufacturers is called, '
      'then it should return a list of car manufacturers',
      () async {
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

        final mockSharedPreferencesService =
            SharedPreferencesService(mockPreferences);
        final service = SharedPreferencesAndNHTSACarManufacturersService(
          dio,
          mockSharedPreferencesService,
        );

        // When
        final carManufacturers = service.fetchLocallySavedCarManufacturers();

        // Then
        expect(
          carManufacturers,
          isA<List<CarManufacturerModel>>(),
        );
        expect(
          carManufacturers,
          equals(fakeManufacturersList),
        );
      },
    );

    test(
      'Given a SharedPreferences instance with an empty list of car manufacturers, '
      'when fetchLocallySavedCarManufacturers is called, '
      'then it should return an empty list of car manufacturers',
      () async {
        // Given
        SharedPreferences.setMockInitialValues({
          SharedPreferencesAndNHTSACarManufacturersService
              .savedCarManufacturersKey: [],
        });
        final mockPreferences = await SharedPreferences.getInstance();

        final mockSharedPreferencesService =
            SharedPreferencesService(mockPreferences);
        final service = SharedPreferencesAndNHTSACarManufacturersService(
          dio,
          mockSharedPreferencesService,
        );

        // When
        final carManufacturers = service.fetchLocallySavedCarManufacturers();

        // Then
        expect(
          carManufacturers,
          isA<List<CarManufacturerModel>>(),
        );
        expect(
          carManufacturers,
          isEmpty,
        );
      },
    );

    test(
        'Given a list of car manufacturers, when fetchCarManufacturersRemotely is called, then it should return a list of car manufacturers',
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
      final mockPreferences = await SharedPreferences.getInstance();
      final mockSharedPreferencesService =
          SharedPreferencesService(mockPreferences);

      dioAdapter.onGet(
        'https://vpic.nhtsa.dot.gov/api/vehicles/getallmanufacturers?format=json&page=1',
        (request) => request.reply(200, {
          'Count': fakeManifacturerRemoteEntities.length,
          'Message': 'Results returned successfully',
          'SearchCriteria': 'Page 1 of 1',
          'Results':
              fakeManifacturerRemoteEntities.map((e) => e.toMap()).toList(),
        }),
      );

      final service = SharedPreferencesAndNHTSACarManufacturersService(
        dio,
        mockSharedPreferencesService,
      );

      // When
      final carManufacturers = await service.fetchCarManufacturersRemotely(
        page: 1,
      );

      // Then
      expect(
        carManufacturers,
        isA<List<CarManufacturerModel>>(),
      );

      final fakeManifacturerModels = fakeManifacturerRemoteEntities
          .map((e) => CarManufacturerModel.fromRemoteEntity(e))
          .toList();
      expect(
        carManufacturers,
        equals(fakeManifacturerModels),
      );
    });

    test(
        'Given a selected car manufcaturer, '
        'when getCarMakes is called, '
        'then a list of car makes is returned', () async {
      // Given
      final fakeCarMakesRemoteEntities = [
        const CarMakeRemoteEntity(
          makeId: 474,
          makeName: 'HONDA',
          mfrName: 'HONDA MOTOR CO., LTD',
        ),
        const CarMakeRemoteEntity(
          makeId: 475,
          makeName: 'ACURA',
          mfrName: 'HONDA MOTOR CO., LTD',
        ),
        const CarMakeRemoteEntity(
          makeId: 542,
          makeName: 'ISUZU',
          mfrName: 'HONDA MOTOR CO., LTD',
        ),
      ];

      final mockPreferences = await SharedPreferences.getInstance();

      final mockSharedPreferencesService =
          SharedPreferencesService(mockPreferences);

      dioAdapter.onGet(
        'https://vpic.nhtsa.dot.gov/api/vehicles/GetMakeForManufacturer/987?format=json',
        (request) => request.reply(200, {
          'Count': fakeCarMakesRemoteEntities.length,
          'Message': 'Results returned successfully',
          'SearchCriteria': 'Manufacturer: 987',
          'Results': fakeCarMakesRemoteEntities.map((e) => e.toMap()).toList(),
        }),
      );

      final service = SharedPreferencesAndNHTSACarManufacturersService(
        dio,
        mockSharedPreferencesService,
      );

      // When
      final carMakes = await service.getCarMakes(987);

      // Then
      expect(
        carMakes,
        isA<List<CarMakeModel>>(),
      );

      final fakeCarMakeModels = fakeCarMakesRemoteEntities
          .map((e) => CarMakeModel.fromRemoteEntity(e))
          .toList();

      expect(
        carMakes,
        equals(fakeCarMakeModels),
      );
    });
  });
}
