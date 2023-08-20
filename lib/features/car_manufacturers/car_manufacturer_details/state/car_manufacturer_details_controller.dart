import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../car_manufacturers.dart';

/// Provider for the selected car manufacturer ID.
@visibleForTesting
final selectedCarManufacturerProvider =
    Provider.autoDispose<CarManufacturerModel?>(
  (ref) {
    final selectedManufacturerId = ref.watch(
      carManufacturersControllerProvider.select(
        (state) => state.selectedManufacturerId,
      ),
    );

    if (selectedManufacturerId == null) return null;

    final manufacturers = ref.watch(
      carManufacturersControllerProvider.select(
        (state) => state.carManufacturers.maybeWhen(
            data: (manufacturers) => manufacturers.values.toList(),
            orElse: () => <CarManufacturerModel?>[]),
      ),
    );

    if (manufacturers.isEmpty) return null;

    final manufacturerIds = manufacturers
        .where((manufacturer) => manufacturer != null)
        .map((manufacturer) => manufacturer!.id)
        .toList();

    if (!manufacturerIds.contains(selectedManufacturerId)) return null;

    return manufacturers
        .where((manufacturer) => manufacturer != null)
        .firstWhere(
          (manufacturer) => manufacturer?.id == selectedManufacturerId,
        );
  },
);

/// Provider for the [CarManufacturerDetailsController].
final carManufacturerDetailsProvider = StateNotifierProvider.autoDispose<
    CarManufacturerDetailsController, CarManufacturerDetailsState>((ref) {
  final manufacturer = ref.watch(selectedCarManufacturerProvider);
  final initialState = CarManufacturerDetailsState(
    manufacturerId: manufacturer?.id,
    manufacturerName: manufacturer?.name,
  );
  return CarManufacturerDetailsController(initialState, ref);
});

class CarManufacturerDetailsController
    extends StateNotifier<CarManufacturerDetailsState> {
  CarManufacturerDetailsController(super.state, this._ref) {
    unawaited(getCarManufacturerDetails());
  }

  final Ref _ref;

  Future<void> getCarManufacturerDetails() async {
    if (state.manufacturerId == null) {
      state = state.copyWith(
        carMakes: AsyncError(
          const NoManufacturerIdException(),
          StackTrace.current,
        ),
      );
      return;
    }

    state = state.copyWith(
      carMakes: const AsyncValue.loading(),
    );

    final service = _ref.read(carManufacturersServiceProvider);

    if (!mounted) return;

    try {
      final makes = await service.getCarMakes(state.manufacturerId!);

      if (!mounted) return;

      state = state.copyWith(
        carMakes: AsyncData({
          for (final make in makes) make.id: make,
        }),
      );
    } catch (error, stackTrace) {
      state = state.copyWith(
        carMakes: AsyncError(error, stackTrace),
      );
    }
  }
}

/// Exception for when there is no manufacturer ID.
class NoManufacturerIdException extends Equatable implements Exception {
  const NoManufacturerIdException();

  @override
  List<Object?> get props => [];
}
