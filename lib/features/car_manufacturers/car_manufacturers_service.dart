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

  FutureOr<List<CarManufacturerModel>> fetchLocallySavedCarManufacturers();

  Future<void> saveCarManufacturersLocally({
    required List<CarManufacturerModel> carManufacturers,
  });
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
  List<CarManufacturerModel> fetchLocallySavedCarManufacturers() {
    final savedManufacturers =
        _sharedPreferencesService.getListOfStringsFromSharedPreferences(
      savedCarManufacturersKey,
    );

    if (savedManufacturers == null || savedManufacturers.isEmpty) {
      return [];
    }

    final carManufacturers =
        savedManufacturers.map((json) => CarManufacturerModel.fromJson(json));

    return carManufacturers.toList();
  }

  @override
  Future<void> saveCarManufacturersLocally({
    required List<CarManufacturerModel> carManufacturers,
  }) async {
    final carManufacturersJson =
        carManufacturers.map((manufacturer) => manufacturer.toJson()).toList();

    await _sharedPreferencesService.saveListOfStringsToSharedPreferences(
      savedCarManufacturersKey,
      carManufacturersJson,
    );
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
