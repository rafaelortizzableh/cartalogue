import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../car_manufacturers.dart';

class CarManufacturerDetailsState extends Equatable {
  const CarManufacturerDetailsState({
    this.manufacturerId,
    this.manufacturerName,
    this.carMakes = const AsyncValue.loading(),
  });

  final int? manufacturerId;
  final String? manufacturerName;
  final AsyncValue<Map<int, CarMakeModel>> carMakes;

  CarManufacturerDetailsState copyWith({
    int? manufacturerId,
    String? manufacturerName,
    AsyncValue<Map<int, CarMakeModel>>? carMakes,
  }) {
    return CarManufacturerDetailsState(
      manufacturerId: manufacturerId ?? this.manufacturerId,
      manufacturerName: manufacturerName ?? this.manufacturerName,
      carMakes: carMakes ?? this.carMakes,
    );
  }

  @override
  List<Object?> get props => [manufacturerId, manufacturerName, carMakes];
}
