import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../car_manufacturers.dart';

class CarMakeModel extends Equatable {
  const CarMakeModel({
    required this.id,
    required this.name,
  });

  factory CarMakeModel.fromMap(Map<String, dynamic> map) {
    return CarMakeModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  factory CarMakeModel.fromRemoteEntity(CarMakeRemoteEntity remoteEntity) {
    return CarMakeModel(
      id: remoteEntity.makeId,
      name: remoteEntity.makeName,
    );
  }

  factory CarMakeModel.fromJson(String source) =>
      CarMakeModel.fromMap(json.decode(source));

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());
}
