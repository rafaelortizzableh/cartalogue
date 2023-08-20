import 'dart:convert';

import 'package:equatable/equatable.dart';

class CarMakeRemoteEntity extends Equatable {
  const CarMakeRemoteEntity({
    required this.makeId,
    required this.makeName,
    required this.mfrName,
  });

  factory CarMakeRemoteEntity.fromMap(Map<String, dynamic> map) {
    return CarMakeRemoteEntity(
      makeId: map['Make_ID']?.toInt() ?? 0,
      makeName: map['Make_Name'] ?? '',
      mfrName: map['Mfr_Name'] ?? '',
    );
  }

  factory CarMakeRemoteEntity.fromJson(String source) =>
      CarMakeRemoteEntity.fromMap(json.decode(source));
  final int makeId;
  final String makeName;
  final String mfrName;

  Map<String, dynamic> toMap() {
    return {
      'Make_ID': makeId,
      'Make_Name': makeName,
      'Mfr_Name': mfrName,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [makeId, makeName, mfrName];
}
