import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'car_manufacturer_remote_entity.dart';

class CarManufacturerModel extends Equatable {
  const CarManufacturerModel({
    required this.name,
    required this.countryName,
    required this.fullName,
    required this.id,
  });

  factory CarManufacturerModel.fromMap(Map<String, dynamic> map) {
    return CarManufacturerModel(
      name: map['name'] ?? '',
      countryName: map['countryName'] ?? '',
      fullName: map['fullName'] ?? '',
      id: map['id']?.toInt() ?? 0,
    );
  }

  factory CarManufacturerModel.fromJson(String source) =>
      CarManufacturerModel.fromMap(json.decode(source));

  factory CarManufacturerModel.fromRemoteEntity(
    CarManufacturerRemoteEntity remoteEntity,
  ) {
    return CarManufacturerModel(
      name: remoteEntity.commonName ?? remoteEntity.name,
      countryName: remoteEntity.country,
      fullName: remoteEntity.name,
      id: remoteEntity.id,
    );
  }

  final String name;
  final String countryName;
  final String fullName;
  final int id;

  @override
  List<Object> get props => [name, countryName, fullName, id];

  CarManufacturerModel copyWith({
    String? name,
    String? countryName,
    String? fullName,
    int? id,
  }) {
    return CarManufacturerModel(
      name: name ?? this.name,
      countryName: countryName ?? this.countryName,
      fullName: fullName ?? this.fullName,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'countryName': countryName,
      'fullName': fullName,
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CarManufacturerModel(name: $name, countryName: $countryName, fullName: $fullName, id: $id)';
  }
}
