import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features.dart';

typedef CarManufacturersMap = Map<int, CarManufacturerModel>;

class CarManufacturersState extends Equatable {
  const CarManufacturersState({
    this.isDeviceOnline = true,
    this.carManufacturers = const AsyncValue.loading(),
    this.lastRemotePageFetched = 0,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  factory CarManufacturersState.initial() {
    return const CarManufacturersState();
  }

  final bool isDeviceOnline;
  final AsyncValue<CarManufacturersMap> carManufacturers;
  final int lastRemotePageFetched;
  final bool isLoadingMore;
  final bool hasReachedMax;

  CarManufacturersState copyWith({
    bool? isDeviceOnline,
    AsyncValue<CarManufacturersMap>? carManufacturers,
    int? lastRemotePageFetched,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return CarManufacturersState(
      isDeviceOnline: isDeviceOnline ?? this.isDeviceOnline,
      carManufacturers: carManufacturers ?? this.carManufacturers,
      lastRemotePageFetched:
          lastRemotePageFetched ?? this.lastRemotePageFetched,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [
        isDeviceOnline,
        carManufacturers,
        lastRemotePageFetched,
        isLoadingMore,
        hasReachedMax,
      ];
}
