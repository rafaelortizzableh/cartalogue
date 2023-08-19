import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CarManufacturerRemoteEntity extends Equatable {
  const CarManufacturerRemoteEntity({
    required this.country,
    this.commonName,
    required this.id,
    required this.name,
    required this.vehicleTypes,
  });

  factory CarManufacturerRemoteEntity.fromMap(Map<String, dynamic> map) {
    return CarManufacturerRemoteEntity(
      country: map['Country'] ?? '',
      commonName: map['Mfr_CommonName'],
      id: map['Mfr_ID']?.toInt() ?? 0,
      name: map['Mfr_Name'] ?? '',
      vehicleTypes: List<VehicleTypeRemoteEntity>.from(
        map['VehicleTypes']?.map(
              (x) => VehicleTypeRemoteEntity.fromMap(x),
            ) ??
            [],
      ),
    );
  }

  factory CarManufacturerRemoteEntity.fromJson(String source) =>
      CarManufacturerRemoteEntity.fromMap(json.decode(source));
  final String country;
  final String? commonName;
  final int id;
  final String name;
  final List<VehicleTypeRemoteEntity> vehicleTypes;

  @visibleForTesting
  Map<String, dynamic> toMap() {
    return {
      'Country': country,
      'Mfr_CommonName': commonName,
      'Mfr_ID': id,
      'Mfr_Name': name,
      'VehicleTypes': vehicleTypes.map((x) => x.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [country, commonName, id, name, vehicleTypes];
}

class VehicleTypeRemoteEntity extends Equatable {
  factory VehicleTypeRemoteEntity.fromMap(Map<String, dynamic> map) {
    return VehicleTypeRemoteEntity(
      isPrimary: map['IsPrimary'] ?? false,
      name: map['Name'] ?? '',
    );
  }

  factory VehicleTypeRemoteEntity.fromJson(String source) =>
      VehicleTypeRemoteEntity.fromMap(json.decode(source));
  const VehicleTypeRemoteEntity({
    required this.isPrimary,
    required this.name,
  });
  final bool isPrimary;
  final String name;

  @visibleForTesting
  Map<String, dynamic> toMap() {
    return {
      'IsPrimary': isPrimary,
      'Name': name,
    };
  }

  @override
  List<Object> get props => [isPrimary, name];
}
