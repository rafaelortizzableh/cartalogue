import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../features.dart';

/// Provider for the [CarManufacturersService].
final carManufacturersServiceProvider = Provider<CarManufacturersService>(
  (ref) => SharedPreferencesAndNHTSACarManufacturersService(
    ref.read(dioProvider),
    ref.read(sharedPreferencesServiceProvider),
  ),
);

abstract class CarManufacturersService {
  Future<List<CarManufacturerModel>> fetchCarManufacturersRemotely({
    required int page,
  });

  FutureOr<({List<CarManufacturerModel> manufacturers, int lastPageFetched})>
      fetchLocallySavedCarManufacturers();

  Future<void> saveCarManufacturersLocally({
    required List<CarManufacturerModel> carManufacturers,
    required int page,
  });

  Future<List<CarMakeModel>> getCarMakes(int manufacturerId);
}

class SharedPreferencesAndNHTSACarManufacturersService
    implements CarManufacturersService {
  SharedPreferencesAndNHTSACarManufacturersService(
    this._dio,
    this._sharedPreferencesService,
  );
  final Dio _dio;
  final SharedPreferencesService _sharedPreferencesService;

  @visibleForTesting
  static const savedCarManufacturersKey = 'saved_car_manufacturers';

  @visibleForTesting
  static const lastPageFetchedKey = 'car_manufacturers_last_page_fetched';

  static const _nhtsaApiBaseUrl = 'https://vpic.nhtsa.dot.gov/api/vehicles';
  static const _defaultFormat = 'json';

  @override
  Future<List<CarManufacturerModel>> fetchCarManufacturersRemotely({
    required int page,
  }) async {
    try {
      final response = await _dio.get(
        '$_nhtsaApiBaseUrl/getallmanufacturers?format=$_defaultFormat&page=$page',
      );
      final manufacturers = response.data['Results'] as List<dynamic>;

      final remoteEntities =
          manufacturers.map((map) => CarManufacturerRemoteEntity.fromMap(map));
      final carManufacturers = remoteEntities
          .map((entity) => CarManufacturerModel.fromRemoteEntity(entity));
      return carManufacturers.toList();
    } on DioException catch (e) {
      final message = e.message ?? 'Something went wrong';
      throw NHTSAApiRequestFailure(
        message: message,
        statusCode: e.response?.statusCode ?? 400,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  ({
    List<CarManufacturerModel> manufacturers,
    int lastPageFetched,
  }) fetchLocallySavedCarManufacturers() {
    final savedManufacturers =
        _sharedPreferencesService.getListOfStringsFromSharedPreferences(
      savedCarManufacturersKey,
    );

    if (savedManufacturers == null || savedManufacturers.isEmpty) {
      return (manufacturers: [], lastPageFetched: 0);
    }
    final lastPageFetched =
        _sharedPreferencesService.getIntFromSharedPreferences(
      lastPageFetchedKey,
    );

    final carManufacturers =
        savedManufacturers.map((json) => CarManufacturerModel.fromJson(json));

    return (
      manufacturers: carManufacturers.toList(),
      lastPageFetched: lastPageFetched ?? 1,
    );
  }

  @override
  Future<void> saveCarManufacturersLocally({
    required List<CarManufacturerModel> carManufacturers,
    required int page,
  }) async {
    final carManufacturersJson =
        carManufacturers.map((manufacturer) => manufacturer.toJson()).toList();

    await Future.wait([
      _sharedPreferencesService.save(
        savedCarManufacturersKey,
        carManufacturersJson,
      ),
      _sharedPreferencesService.save(
        lastPageFetchedKey,
        page,
      ),
    ]);
  }

  @override
  Future<List<CarMakeModel>> getCarMakes(int manufacturerId) async {
    try {
      final response = await _dio.get(
        '$_nhtsaApiBaseUrl/GetMakeForManufacturer/$manufacturerId?format=$_defaultFormat',
      );

      final makes = response.data['Results'] as List<dynamic>;

      final remoteEntities =
          makes.map((map) => CarMakeRemoteEntity.fromMap(map));

      final carMakes =
          remoteEntities.map((entity) => CarMakeModel.fromRemoteEntity(entity));

      return carMakes.toList();
    } on DioException catch (e) {
      final message = e.message ?? 'Something went wrong';
      throw NHTSAApiRequestFailure(
        message: message,
        statusCode: e.response?.statusCode ?? 400,
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Exception thrown when the request to the NHTSA API fails.
class NHTSAApiRequestFailure extends Equatable implements Exception {
  const NHTSAApiRequestFailure({
    required this.message,
    required this.statusCode,
  });
  final String message;
  final int statusCode;

  @override
  List<Object> get props => [message, statusCode];
}
