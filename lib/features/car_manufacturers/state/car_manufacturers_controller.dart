import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

final carManufacturersControllerProvider = StateNotifierProvider.autoDispose<
    CarManufacturersController, CarManufacturersState>(
  (ref) => CarManufacturersController(
    CarManufacturersState.initial(),
    ref,
  ),
);

class CarManufacturersController extends StateNotifier<CarManufacturersState> {
  CarManufacturersController(super.state, this._ref) {
    addListener(_saveManufacturersToSharedPreferences);
    unawaited(init());
  }

  final Ref _ref;

  Future<void> fetchLocallySavedCarManufacturers() async {
    state = state.copyWith(
      carManufacturers: const AsyncValue.loading(),
    );
    try {
      final carManufacturersService =
          _ref.read(carManufacturersServiceProvider);
      final carManufacturers =
          await carManufacturersService.fetchLocallySavedCarManufacturers();
      state = CarManufacturersState(
        carManufacturers: AsyncValue.data({
          for (final manufacturer in carManufacturers.manufacturers) ...{
            manufacturer.id: manufacturer,
          },
        }),
        isDeviceOnline: false,
        lastRemotePageFetched: carManufacturers.lastPageFetched,
      );
    } catch (e, stackTrace) {
      state = CarManufacturersState(
        carManufacturers: AsyncValue.error(e, stackTrace),
        isDeviceOnline: false,
        lastRemotePageFetched: 0,
      );
    }
  }

  Future<void> fetchCarManufacturersRemotely() async {
    state = state.copyWith(
      isLoadingMore: true,
    );
    final pageToFetch = state.lastRemotePageFetched + 1;
    try {
      final carManufacturersService =
          _ref.read(carManufacturersServiceProvider);
      final fetchedCarManufacturers =
          await carManufacturersService.fetchCarManufacturersRemotely(
        page: pageToFetch,
      );

      final carManufacturers = {
        ...state.carManufacturers.asData?.value ?? {},
        for (final manufacturer in fetchedCarManufacturers) ...{
          manufacturer.id: manufacturer,
        }
      };

      state = CarManufacturersState(
        carManufacturers: AsyncValue.data(carManufacturers),
        isDeviceOnline: true,
        isLoadingMore: false,
        lastRemotePageFetched: state.lastRemotePageFetched + 1,
      );
    } catch (error, stackTrace) {
      state = CarManufacturersState(
        carManufacturers: AsyncValue.error(error, stackTrace),
        isDeviceOnline: true,
        isLoadingMore: false,
        lastRemotePageFetched: pageToFetch - 1,
      );
    }
  }

  @visibleForTesting
  Future<void> init() async {
    final connectivityResult =
        await _ref.read(connectivityProvider).checkConnectivity();
    final isDeviceOnline = connectivityResult != ConnectivityResult.none;

    if (!mounted) return;
    if (!isDeviceOnline) {
      await fetchLocallySavedCarManufacturers();
      return;
    }

    if (!mounted) return;
    await fetchCarManufacturersRemotely();
  }

  Future<void> _saveManufacturersToSharedPreferences(
    CarManufacturersState state,
  ) async {
    final carManufacturers = state.carManufacturers.asData?.value;
    if (carManufacturers == null) return;
    if (carManufacturers.isEmpty) return;
    final carManufacturersService = _ref.read(carManufacturersServiceProvider);
    final currentlySavedManufacturers =
        await carManufacturersService.fetchLocallySavedCarManufacturers();
    final carManifacturersToSave = carManufacturers.values.toList();
    if (currentlySavedManufacturers.manufacturers == carManifacturersToSave) {
      return;
    }
    if (!mounted) return;

    unawaited(carManufacturersService.saveCarManufacturersLocally(
      carManufacturers: carManifacturersToSave,
      page: state.lastRemotePageFetched,
    ));
  }

  void selectManufacturer(int manufacturerId) {
    state = state.copyWith(
      selectedManufacturerId: manufacturerId,
    );
  }
}
