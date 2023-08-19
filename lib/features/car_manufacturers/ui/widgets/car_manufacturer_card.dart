import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class CarManufacturerCard extends StatelessWidget {
  const CarManufacturerCard({
    super.key,
    required this.manufacturer,
    required this.onTap,
  });
  final CarManufacturerModel manufacturer;
  final Function(CarManufacturerModel) onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: AppConstants.roundedRectangleBorder12,
        onTap: () => onTap(manufacturer),
        title: Text(manufacturer.name),
        subtitle: Text(manufacturer.countryName),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
