import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../car_manufacturer_details.dart';

class CarManufacturerDetailsContent extends StatelessWidget {
  const CarManufacturerDetailsContent({
    super.key,
    required this.manufacturerName,
    required this.carMakes,
    required this.isCarMakesListLoading,
  });

  final String manufacturerName;
  final List<CarMakeModel> carMakes;
  final bool isCarMakesListLoading;

  @override
  Widget build(BuildContext context) {
    if (isCarMakesListLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: GenericLoader(),
        ),
      );
    }
    return CarManufacturerDetails(
      manufacturerName: manufacturerName,
      carMakes: carMakes,
    );
  }
}
